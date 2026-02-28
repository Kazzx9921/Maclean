import SwiftUI

struct ScanView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var l10n: L10n
    private let scanEngine = ScanEngine()
    private let cleanEngine = CleanEngine()

    var body: some View {
        VStack(spacing: 0) {
            switch appState.phase {
            case .idle, .scanning:
                scanningView
            case .scanned:
                if appState.scanResults.isEmpty {
                    emptyView
                } else {
                    scanResultsView
                }
            case .executing:
                ExecuteView()
            case .completed:
                ExecuteView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(l10n.scan)
        .task {
            if appState.phase == .idle {
                startScan()
            }
        }
        .onChange(of: appState.phase) {
            if appState.phase == .idle {
                startScan()
            }
        }
    }

    private var scanningView: some View {
        ScanningAnimationView(title: l10n.scanning, fileLog: appState.scanFileLog)
            .padding()
    }

    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 48))
                .foregroundStyle(.green)

            Text(l10n.noJunkFound)
                .font(.title2.bold())

            Text(l10n.noJunkFoundDesc)
                .foregroundStyle(.secondary)

            Button(action: startScan) {
                Label(l10n.rescan, systemImage: "arrow.clockwise")
                    .frame(minWidth: 140)
            }
            .glassProminentButtonStyle()
            .controlSize(.large)
        }
        .padding()
    }

    private var scanResultsView: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(Array(appState.scanResults.enumerated()), id: \.element.id) { index, _ in
                        CategoryCardView(result: binding(for: index))
                    }
                }
                .padding()
            }

            bottomBar
        }
    }

    private var allSelected: Bool {
        !appState.scanResults.isEmpty && appState.scanResults.allSatisfy { cat in cat.items.allSatisfy(\.isSelected) }
    }

    private var bottomBar: some View {
        HStack {
            Button(action: toggleSelectAll) {
                Text(allSelected ? l10n.deselectAll : l10n.selectAll)
            }
            .glassProminentButtonStyle()
            .controlSize(.large)

            Spacer()

            let totalSize = appState.scanResults.reduce(0 as Int64) { $0 + $1.totalSize }
            let totalFiles = appState.scanResults.reduce(0) { $0 + $1.selectedCount }

            Text(l10n.itemsSummary(totalFiles, FileSize.formatted(totalSize)))
                .foregroundStyle(.secondary)

            Spacer()

            Button(action: executeClean) {
                Text(l10n.executeClean)
            }
            .glassProminentButtonStyle()
            .controlSize(.large)
            .disabled(totalFiles == 0)
        }
        .padding()
        .glassBar()
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    private func toggleSelectAll() {
        let newValue = !allSelected
        for i in appState.scanResults.indices {
            for j in appState.scanResults[i].items.indices {
                appState.scanResults[i].items[j].isSelected = newValue
            }
        }
    }

    private func binding(for index: Int) -> Binding<CategoryResult> {
        Binding(
            get: { appState.scanResults[index] },
            set: { appState.scanResults[index] = $0 }
        )
    }

    private func startScan() {
        appState.phase = .scanning
        Task {
            do {
                let whitelist = WhitelistService.shared.entries
                let results = try await scanEngine.scan(whitelist: whitelist) { file in
                    appState.appendScanFile(file)
                }
                appState.scanResults = results
                appState.phase = .scanned
            } catch {
                appState.reset()
            }
        }
    }

    private func executeClean() {
        let report = DryRunReport(categories: appState.scanResults)
        appState.dryRunReport = report
        appState.phase = .executing

        Task {
            let summary = await cleanEngine.deleteItems(report: report) { progress, file in
                appState.progress = progress
                appState.currentFile = file
            }
            appState.cleanSummary = summary

            HistoryService.shared.add(
                CleanHistory(
                    date: summary.completedAt,
                    totalCleaned: summary.totalCleaned,
                    filesRemoved: summary.filesRemoved,
                    categories: report.categories.map {
                        CleanHistory.CategorySummary(name: $0.category, size: $0.totalSize, count: $0.selectedCount)
                    }
                )
            )

            appState.phase = .completed
        }
    }
}
