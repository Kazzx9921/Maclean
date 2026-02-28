import SwiftUI

struct DiskStatusBar: View {
    @EnvironmentObject var l10n: L10n
    @State private var totalSpace: Int64 = 0
    @State private var freeSpace: Int64 = 0
    @State private var isHovering = false

    private var usedSpace: Int64 { totalSpace - freeSpace }
    private var usageRatio: Double {
        guard totalSpace > 0 else { return 0 }
        return Double(usedSpace) / Double(totalSpace)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(l10n.diskUsage)
                    .font(.headline)

                RefreshButton { fetchDiskSpace() }
                    .opacity(isHovering ? 1 : 0)

                Spacer()
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.quaternary)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(barGradient)
                        .frame(width: geo.size.width * usageRatio)
                }
            }
            .frame(height: 12)

            HStack {
                Label(l10n.diskUsed(FileSize.formatted(usedSpace), FileSize.formatted(totalSpace)), systemImage: "internaldrive")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(l10n.diskFree(FileSize.formatted(freeSpace)))
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .glassBackground()
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
        .task {
            try? await Task.sleep(for: .zero)
            fetchDiskSpace()
        }
    }

    private var barGradient: LinearGradient {
        let color: Color = usageRatio > 0.9 ? .red : usageRatio > 0.75 ? .orange : .blue
        return LinearGradient(colors: [color.opacity(0.8), color], startPoint: .leading, endPoint: .trailing)
    }

    private func fetchDiskSpace() {
        guard let attrs = try? FileManager.default.attributesOfFileSystem(
            forPath: NSHomeDirectory()
        ) else { return }

        totalSpace = (attrs[.systemSize] as? Int64) ?? 0
        freeSpace = (attrs[.systemFreeSize] as? Int64) ?? 0
    }
}

// MARK: - Refresh Button

private struct RefreshButton: View {
    let action: () -> Void
    @State private var isButtonHovering = false
    @State private var rotation: Double = 0

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.5)) {
                rotation += 360
            }
            action()
        } label: {
            Image(systemName: "arrow.clockwise")
                .font(.caption)
                .foregroundStyle(isButtonHovering ? .primary : .secondary)
                .rotationEffect(.degrees(rotation))
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isButtonHovering ? AnyShapeStyle(.quaternary) : AnyShapeStyle(.clear))
                )
        }
        .buttonStyle(.plain)
        .onHover { isButtonHovering = $0 }
    }
}
