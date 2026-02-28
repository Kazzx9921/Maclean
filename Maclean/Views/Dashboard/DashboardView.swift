import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var l10n: L10n
    @EnvironmentObject var historyService: HistoryService

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                DiskStatusBar()

                if !historyService.entries.isEmpty {
                    lifetimeStats
                    historyList
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(l10n.dashboard)
        .toolbar {
            if !historyService.entries.isEmpty {
                Button(l10n.clearAll, role: .destructive) {
                    historyService.clearAll()
                }
            }
        }
    }

    // MARK: - Lifetime Stats

    private var lifetimeStats: some View {
        HStack {
            let totalCleaned = historyService.entries.reduce(0 as Int64) { $0 + $1.totalCleaned }
            let totalFiles = historyService.entries.reduce(0) { $0 + $1.filesRemoved }
            let sessions = historyService.entries.count

            statItem(FileSize.formatted(totalCleaned), l10n.totalCleanedAllTime)
            Divider().frame(height: 40)
            statItem("\(totalFiles)", l10n.filesRemoved)
            Divider().frame(height: 40)
            statItem("\(sessions)", l10n.totalSessions)
        }
        .padding()
        .glassBackground()
    }

    private func statItem(_ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title.bold())
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - History List

    private var historyList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(l10n.history)
                .font(.headline)
                .padding(.horizontal, 14)
                .padding(.top, 12)
                .padding(.bottom, 8)

            ForEach(Array(historyService.entries.enumerated()), id: \.element.id) { index, entry in
                if index > 0 {
                    Divider().padding(.horizontal, 14)
                }

                NavigationLink {
                    HistoryDetailView(entry: entry)
                } label: {
                    historyRow(entry)
                }
                .buttonStyle(.plain)
            }
        }
        .glassBackground()
    }

    private func historyRow(_ entry: CleanHistory) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(l10n.formattedDate(entry.date))
                    .font(.body.bold())
                Text("\(entry.filesRemoved) \(l10n.filesRemoved)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            FileSizeLabel(bytes: entry.totalCleaned)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .contentShape(Rectangle())
    }
}
