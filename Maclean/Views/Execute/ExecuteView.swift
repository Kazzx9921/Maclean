import SwiftUI

struct ExecuteView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var l10n: L10n
    private let cleanEngine = CleanEngine()

    var body: some View {
        VStack(spacing: 24) {
            switch appState.phase {
            case .executing:
                executingContent
            case .pendingConfirm:
                pendingConfirmContent
            case .completed:
                completedContent
            default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    // MARK: - Executing (progress bar)
    private var executingContent: some View {
        VStack(spacing: 16) {
            ProgressView(value: appState.progress)
                .progressViewStyle(.linear)
                .frame(maxWidth: 400)

            Text("\(Int(appState.progress * 100))%")
                .font(.title.bold().monospacedDigit())

            Text(appState.currentFile)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .truncationMode(.middle)
                .frame(maxWidth: 400)
        }
    }

    // MARK: - Pending Confirm (files in trash, user tests apps)
    private var pendingConfirmContent: some View {
        VStack(spacing: 16) {
            Text(l10n.movedToTrash)
                .font(.title2.bold())

            Text(l10n.movedToTrashDesc)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 400)

            if let summary = appState.cleanSummary {
                VStack(spacing: 8) {
                    summaryRow(l10n.spaceFreed, FileSize.formatted(summary.totalCleaned))
                    summaryRow(l10n.filesRemoved, "\(summary.filesRemoved)")

                    if !summary.errors.isEmpty {
                        summaryRow(l10n.errors, "\(summary.errors.count)")
                            .foregroundStyle(.red)
                    }
                }
                .padding()
                .glassBackground()
            }

            HStack(spacing: 16) {
                Button(action: restoreAll) {
                    Text(l10n.restoreAll)
                }
                .glassButtonStyle()
                .controlSize(.large)

                Button(action: confirmPermanentDelete) {
                    Text(l10n.confirmPermanentDelete)
                }
                .glassProminentButtonStyle()
                .tint(.red)
                .controlSize(.large)
            }
        }
    }

    // MARK: - Completed (final state)
    private var completedContent: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.green)

            if let summary = appState.cleanSummary {
                Text(l10n.freedSpace(FileSize.formatted(summary.totalCleaned)))
                    .font(.title2.bold())

                VStack(spacing: 8) {
                    summaryRow(l10n.filesRemoved, "\(summary.filesRemoved)")
                    summaryRow(l10n.duration, String(format: "%.1fs", summary.duration))
                }
                .padding()
                .glassBackground()
            }

            Button(l10n.done) {
                appState.scanResults = []
                appState.dryRunReport = nil
                appState.cleanSummary = nil
                appState.progress = 0
                appState.currentFile = ""
                appState.scanFileLog = []
                appState.phase = .scanned
            }
            .glassProminentButtonStyle()
            .controlSize(.large)
        }
    }

    // MARK: - Actions
    private func restoreAll() {
        guard let summary = appState.cleanSummary else { return }
        Task {
            _ = await cleanEngine.restore(summary: summary)
            // Go back to scan results so user can re-scan or adjust
            appState.cleanSummary = nil
            appState.dryRunReport = nil
            appState.phase = .scanned
        }
    }

    private func confirmPermanentDelete() {
        guard let summary = appState.cleanSummary else { return }

        appState.progress = 0
        appState.currentFile = ""
        appState.phase = .executing

        Task {
            _ = await cleanEngine.confirmPermanentDelete(summary: summary) { pct, file in
                appState.progress = pct
                appState.currentFile = file
            }

            HistoryService.shared.add(
                CleanHistory(
                    date: summary.completedAt,
                    totalCleaned: summary.totalCleaned,
                    filesRemoved: summary.filesRemoved,
                    categories: appState.dryRunReport?.categories.map {
                        CleanHistory.CategorySummary(name: $0.category, size: $0.totalSize, count: $0.selectedCount)
                    } ?? []
                )
            )

            appState.phase = .completed
        }
    }

    private func summaryRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
        .frame(maxWidth: 300)
    }
}
