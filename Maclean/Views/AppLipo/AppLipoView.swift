import SwiftUI

struct AppLipoView: View {
    @EnvironmentObject var vm: AppLipoViewModel
    @EnvironmentObject var l10n: L10n
    #if APPSTORE
    @EnvironmentObject var storeService: StoreService
    #endif

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
        .navigationTitle(l10n.appLipo)
        #if APPSTORE
        .sheet(isPresented: $storeService.showPaywall) {
            PaywallView()
        }
        .onChange(of: vm.phase) {
            if vm.phase == .done {
                storeService.addCleaned(vm.savedSize)
            }
        }
        #endif
        .task { if vm.phase == .idle { vm.startScan() } }
    }

    // MARK: - Scanning

    private var scanningView: some View {
        ScanningAnimationView(title: l10n.scanningArchitectures, fileLog: vm.fileLog)
            .padding()
    }

    // MARK: - Empty

    private var emptyView: some View {
        ContentUnavailableView(
            l10n.noUniversalApps,
            systemImage: "scissors",
            description: Text(l10n.noUniversalAppsDesc)
        )
    }

    // MARK: - Loaded

    private var loadedView: some View {
        VStack(spacing: 0) {
            // Warning banner
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                Text(l10n.lipoWarning)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassBackground()
            .padding(.horizontal)
            .padding(.top, 8)

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(Array(vm.apps.enumerated()), id: \.element.id) { index, app in
                        UniversalAppRow(app: appBinding(for: index))
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

            Button(action: thinSelected) {
                Text(l10n.thinApps)
            }
            .glassProminentButtonStyle()
            .tint(.orange)
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

            Text(l10n.appsThinned)
                .font(.title2.bold())

            VStack(spacing: 8) {
                summaryRow(l10n.appsRemovedCount, "\(vm.thinnedCount)")
                summaryRow(l10n.spaceFreed, FileSize.formatted(vm.savedSize))
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

    private func thinSelected() {
        #if APPSTORE
        if storeService.requiresPayment {
            storeService.showPaywall = true
            return
        }
        #endif
        vm.thinSelected()
    }

    private func appBinding(for index: Int) -> Binding<UniversalAppInfo> {
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

// MARK: - Universal App Row

struct UniversalAppRow: View {
    @Binding var app: UniversalAppInfo
    @EnvironmentObject var l10n: L10n

    var body: some View {
        HStack(spacing: 12) {
            Toggle("", isOn: $app.isSelected)
                .toggleStyle(.checkbox)
                .labelsHidden()

            AppIconView(path: app.path)

            VStack(alignment: .leading, spacing: 2) {
                Text(app.name)
                    .font(.body.bold())
                    .lineLimit(1)

                Text(l10n.potentialSavings + ": " + FileSize.formatted(app.removableArchSize))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(FileSize.formatted(app.currentArchSize + app.removableArchSize))
                .font(.callout.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .glassBackground()
    }
}
