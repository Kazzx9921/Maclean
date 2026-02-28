import SwiftUI

struct CategoryDetailView: View {
    @Binding var result: CategoryResult

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(result.items.enumerated()), id: \.element.id) { index, item in
                CategoryItemRow(item: item, isSelected: binding(for: index))

                if index < result.items.count - 1 {
                    Divider().padding(.leading, 40)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func binding(for index: Int) -> Binding<Bool> {
        Binding(
            get: { result.items[index].isSelected },
            set: { result.items[index].isSelected = $0 }
        )
    }
}

private struct CategoryItemRow: View {
    let item: CleanItem
    @Binding var isSelected: Bool
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 8) {
            Toggle("", isOn: $isSelected)
                .toggleStyle(.checkbox)
                .labelsHidden()

            Button {
                openInFinder()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: item.isDirectory ? "folder.fill" : "doc")
                        .foregroundStyle(item.isDirectory ? .blue : .secondary)

                    Text(item.name)
                        .lineLimit(1)
                        .truncationMode(.middle)

                    Spacer()

                    if isHovered {
                        Image(systemName: "folder.badge.questionmark")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }

                    FileSizeLabel(bytes: item.size)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .onHover { isHovered = $0 }
    }

    private func openInFinder() {
        if item.isDirectory {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: item.path.path(percentEncoded: false))
        } else {
            NSWorkspace.shared.activateFileViewerSelecting([item.path])
        }
    }
}
