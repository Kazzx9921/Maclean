import SwiftUI

struct CategoryCardView: View {
    @Binding var result: CategoryResult
    @EnvironmentObject var l10n: L10n
    @State private var isExpanded = false

    private var allSelected: Bool {
        result.items.allSatisfy(\.isSelected)
    }

    private var noneSelected: Bool {
        result.items.allSatisfy { !$0.isSelected }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            if isExpanded {
                Divider()
                CategoryDetailView(result: $result)
            }
        }
        .glassBackground()
    }

    private var header: some View {
        HStack(spacing: 12) {
            Toggle("", isOn: categoryToggle)
                .toggleStyle(.checkbox)
                .labelsHidden()

            Button {
                withAnimation(.snappy) { isExpanded.toggle() }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: result.icon)
                        .font(.title2)
                        .foregroundStyle(.tint)
                        .frame(width: 36, height: 36)
                        .background(.tint.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(l10n.categoryLocalizedName(for: result.category))
                            .font(.headline)
                        Text(l10n.categoryDescription(for: result.category))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        FileSizeLabel(bytes: result.totalSize)
                        Text(l10n.itemsCount(result.items.count))
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.tertiary)
                        .font(.caption)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding()
    }

    private var categoryToggle: Binding<Bool> {
        Binding(
            get: { allSelected },
            set: { newValue in
                for i in result.items.indices {
                    result.items[i].isSelected = newValue
                }
            }
        )
    }
}
