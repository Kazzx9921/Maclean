import SwiftUI

struct ExecuteView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var l10n: L10n

    var body: some View {
        VStack(spacing: 24) {
            switch appState.phase {
            case .executing:
                executingContent
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
                appState.reset()
            }
            .glassProminentButtonStyle()
            .controlSize(.large)
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
