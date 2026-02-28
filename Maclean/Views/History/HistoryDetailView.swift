import SwiftUI

struct HistoryDetailView: View {
    @EnvironmentObject var l10n: L10n
    let entry: CleanHistory

    var body: some View {
        List {
            Section(l10n.summary) {
                LabeledContent(l10n.date, value: l10n.formattedDate(entry.date))
                LabeledContent(l10n.totalCleaned, value: FileSize.formatted(entry.totalCleaned))
                LabeledContent(l10n.filesRemoved, value: "\(entry.filesRemoved)")
            }

            Section(l10n.categories) {
                ForEach(entry.categories, id: \.name) { cat in
                    HStack {
                        Text(l10n.categoryLocalizedName(for: cat.name))
                        Spacer()
                        Text(l10n.itemsCount(cat.count))
                            .foregroundStyle(.secondary)
                        FileSizeLabel(bytes: cat.size)
                    }
                }
            }
        }
        .navigationTitle(l10n.cleaningDetails)
    }
}
