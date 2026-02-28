import SwiftUI

struct AppManagerView: View {
    @EnvironmentObject var vm: AppManagerViewModel
    @EnvironmentObject var l10n: L10n

    var body: some View {
        VStack(spacing: 0) {
            switch vm.phase {
            case .idle, .scanning:
                scanningView
            case .loaded:
                if vm.apps.isEmpty {
                    emptyView
                } else {
                    loadedView
                }
            case .removing:
                removingView
            case .done:
                doneView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(l10n.appManager)
        .task { if vm.phase == .idle { vm.startScan() } }
    }

    // MARK: - Scanning

    private var scanningView: some View {
        ScanningAnimationView(title: l10n.scanningApps, fileLog: vm.fileLog)
            .padding()
    }

    // MARK: - Empty

    private var emptyView: some View {
        ContentUnavailableView(
            l10n.noIdleApps,
            systemImage: "app.badge.checkmark",
            description: Text(l10n.noIdleAppsDesc)
        )
    }

    // MARK: - Loaded

    private var loadedView: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(Array(vm.apps.enumerated()), id: \.element.id) { index, _ in
                        AppInfoRow(app: appBinding(for: index))
                    }
                }
                .padding()
            }

            loadedBottomBar
        }
    }

    private var loadedBottomBar: some View {
        HStack {
            Button(action: vm.toggleSelectAll) {
                Text(vm.allSelected ? l10n.deselectAll : l10n.selectAll)
            }
            .glassProminentButtonStyle()
            .controlSize(.large)

            Spacer()

            Text(l10n.itemsSummary(vm.selectedApps.count, FileSize.formatted(vm.selectedTotalSize)))
                .foregroundStyle(.secondary)

            Spacer()

            Button(action: removeSelected) {
                Text(l10n.cleanApps)
            }
            .glassProminentButtonStyle()
            .tint(.red)
            .controlSize(.large)
            .disabled(vm.selectedApps.isEmpty)
        }
        .padding()
        .glassBar()
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    // MARK: - Removing

    private var removingView: some View {
        VStack(spacing: 16) {
            ProgressView(value: vm.progress)
                .progressViewStyle(.linear)
                .frame(maxWidth: 400)

            Text("\(Int(vm.progress * 100))%")
                .font(.title.bold().monospacedDigit())

            Text(l10n.removingProgress(vm.removingCurrent, vm.removingTotal))
                .font(.callout.monospacedDigit())
                .foregroundStyle(.secondary)

            Text(vm.currentAppName)
                .foregroundStyle(.tertiary)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.middle)
                .frame(maxWidth: 400)
        }
        .padding()
    }

    // MARK: - Done

    private var doneView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.green)

            Text(l10n.appsRemoved)
                .font(.title2.bold())

            VStack(spacing: 8) {
                summaryRow(l10n.appsRemovedCount, "\(vm.removedCount)")
                summaryRow(l10n.spaceFreed, FileSize.formatted(vm.removedSize))
            }
            .padding()
            .glassBackground()

            Button(action: vm.rescan) {
                Label(l10n.rescan, systemImage: "arrow.clockwise")
                    .frame(minWidth: 140)
            }
            .glassProminentButtonStyle()
            .controlSize(.large)
        }
        .padding()
    }

    // MARK: - Helpers

    private func removeSelected() {
        vm.removeSelected()
    }

    private func appBinding(for index: Int) -> Binding<AppInfo> {
        Binding(
            get: { vm.apps[index] },
            set: { vm.apps[index] = $0 }
        )
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
