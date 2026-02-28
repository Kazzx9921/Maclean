import SwiftUI

struct ProjectInfoRow: View {
    @Binding var project: ProjectInfo
    @EnvironmentObject var l10n: L10n

    var body: some View {
        HStack(spacing: 12) {
            Toggle("", isOn: $project.isSelected)
                .toggleStyle(.checkbox)
                .labelsHidden()

            Image(systemName: iconForType(project.artifactType))
                .font(.title2)
                .foregroundStyle(.secondary)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(project.name)
                        .font(.body.bold())
                        .lineLimit(1)

                    Text(project.artifactPath.lastPathComponent)
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.quaternary)
                        .clipShape(Capsule())
                }

                Text(project.artifactPath.path(percentEncoded: false)
                    .replacingOccurrences(
                        of: FileManager.default.homeDirectoryForCurrentUser.path(percentEncoded: false),
                        with: "~/"
                    ))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }

            Spacer()

            if let date = project.lastModified {
                Text(l10n.relativeDate(date))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Text(FileSize.formatted(project.size))
                .font(.callout.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .glassBackground()
    }

    private func iconForType(_ type: String) -> String {
        switch type {
        case "Node.js", "Next.js": "shippingbox"
        case "Rust/Maven": "gearshape.2"
        case "Gradle": "building.columns"
        case "Python", "Python Test", "Python Tox", "Python Venv": "chevron.left.forwardslash.chevron.right"
        case "CocoaPods": "cube"
        case "Swift SPM": "swift"
        case "Flutter/Dart": "arrow.triangle.2.circlepath"
        default: "folder"
        }
    }
}
