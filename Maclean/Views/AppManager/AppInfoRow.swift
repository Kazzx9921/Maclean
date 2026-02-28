import SwiftUI

struct AppIconView: View {
    let path: URL

    var body: some View {
        Image(nsImage: NSWorkspace.shared.icon(forFile: path.path(percentEncoded: false)))
            .resizable()
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct AppInfoRow: View {
    @Binding var app: AppInfo
    @EnvironmentObject var l10n: L10n
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            mainRow
            if isExpanded {
                expandedContent
                    .padding(.top, 8)
            }
        }
        .padding(12)
        .glassBackground()
    }

    private var mainRow: some View {
        HStack(spacing: 12) {
            Toggle("", isOn: $app.isSelected)
                .toggleStyle(.checkbox)
                .labelsHidden()

            AppIconView(path: app.path)

            VStack(alignment: .leading, spacing: 2) {
                Text(app.name)
                    .font(.body.bold())
                    .lineLimit(1)

                if let date = app.lastUsedDate {
                    Text(l10n.lastUsed(date))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text(l10n.neverUsed)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Text(FileSize.formatted(app.totalSize))
                .font(.callout.monospacedDigit())
                .foregroundStyle(.secondary)

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
            }
            .buttonStyle(.plain)
        }
    }

    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()

            if !app.associatedPaths.isEmpty {
                Toggle(l10n.includeAppData, isOn: $app.includeAssociatedData)
                    .font(.callout)

                if app.includeAssociatedData {
                    ForEach(app.associatedPaths) { assoc in
                        AssociatedPathRow(assoc: assoc)
                    }
                }
            } else {
                Text(l10n.noAssociatedData)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.leading, 36)
    }
}

private struct AssociatedPathRow: View {
    let assoc: AssociatedPath
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: iconForKind(assoc.kind))
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 16)

            Button {
                NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: assoc.url.path(percentEncoded: false))
            } label: {
                Text(assoc.relativePath)
                    .font(.caption)
                    .foregroundStyle(isHovered ? .primary : .secondary)
                    .underline(isHovered)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            .buttonStyle(.plain)
            .onHover { isHovered = $0 }

            Spacer()

            Text(FileSize.formatted(assoc.size))
                .font(.caption.monospacedDigit())
                .foregroundStyle(.tertiary)
        }
    }

    private func iconForKind(_ kind: AssociatedPath.Kind) -> String {
        switch kind {
        case .appSupport: "folder"
        case .caches: "internaldrive"
        case .preferences: "doc.text"
        }
    }
}
