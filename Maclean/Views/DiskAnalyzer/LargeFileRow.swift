import SwiftUI

struct LargeFileRow: View {
    @Binding var file: LargeFileInfo
    @EnvironmentObject var l10n: L10n

    var body: some View {
        HStack(spacing: 12) {
            Toggle("", isOn: $file.isSelected)
                .toggleStyle(.checkbox)
                .labelsHidden()

            Image(systemName: iconForCategory(file.category))
                .font(.title2)
                .foregroundStyle(.secondary)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(file.name)
                    .font(.body.bold())
                    .lineLimit(1)

                Text(file.relativePath)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }

            Spacer()

            if let date = file.modificationDate {
                Text(l10n.relativeDate(date))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Text(FileSize.formatted(file.size))
                .font(.callout.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .glassBackground()
    }

    private func iconForCategory(_ category: FileCategory) -> String {
        switch category {
        case .all: "doc"
        case .video: "film"
        case .archive: "doc.zipper"
        case .diskImage: "opticaldiscdrive"
        case .installer: "shippingbox"
        case .vm: "desktopcomputer"
        case .other: "doc.fill"
        }
    }
}
