import SwiftUI

struct DiskAnalyzerView: View {
    @EnvironmentObject var vm: DiskAnalyzerViewModel
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
                if vm.files.isEmpty {
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
        .navigationTitle(l10n.diskAnalyzer)
        #if APPSTORE
        .sheet(isPresented: $storeService.showPaywall) {
            PaywallView()
        }
        .onChange(of: vm.phase) {
            if vm.phase == .done {
                storeService.addCleaned(vm.removedSize)
            }
        }
        #endif
        .task { if vm.phase == .idle { vm.startScan() } }
    }

    private var scanningView: some View {
        ScanningAnimationView(title: l10n.scanningDisk, fileLog: vm.fileLog)
            .padding()
    }

    private var emptyView: some View {
        ContentUnavailableView(
            l10n.noLargeFiles,
            systemImage: "chart.pie",
            description: Text(l10n.noLargeFilesDesc)
        )
    }

    private var loadedView: some View {
        VStack(spacing: 0) {
            filterBar

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(Array(vm.filteredFiles.enumerated()), id: \.element.id) { _, file in
                        if let globalIndex = vm.files.firstIndex(where: { $0.id == file.id }) {
                            LargeFileRow(
                                file: Binding(
                                    get: { vm.files[globalIndex] },
                                    set: { vm.files[globalIndex] = $0 }
                                )
                            )
                        }
                    }
                }
                .padding()
            }

            bottomBar
        }
    }

    private var filterBar: some View {
        Group {
            if #available(macOS 26.0, *) {
                Picker("", selection: $vm.selectedFilter) {
                    ForEach(FileCategory.allCases, id: \.self) { category in
                        Text(filterLabel(category)).tag(category)
                    }
                }
                .pickerStyle(.palette)
                .labelsHidden()
                .padding(.horizontal)
                .padding(.vertical, 8)
            } else {
                Picker("", selection: $vm.selectedFilter) {
                    ForEach(FileCategory.allCases, id: \.self) { category in
                        Text(filterLabel(category)).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
    }

    private var bottomBar: some View {
        HStack {
            Button(action: vm.toggleSelectAll) {
                Text(vm.allSelected ? l10n.deselectAll : l10n.selectAll)
            }
            .glassProminentButtonStyle()
            .controlSize(.large)

            Spacer()

            Text(l10n.itemsSummary(vm.selectedFiles.count, FileSize.formatted(vm.selectedTotalSize)))
                .foregroundStyle(.secondary)

            Spacer()

            Button(action: removeSelected) {
                Text(l10n.cleanFiles)
            }
            .glassProminentButtonStyle()
            .tint(.red)
            .controlSize(.large)
            .disabled(vm.selectedFiles.isEmpty)
        }
        .padding()
        .glassBar()
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

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
        }
        .padding()
    }

    private var doneView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.green)

            Text(l10n.filesCleaned)
                .font(.title2.bold())

            VStack(spacing: 8) {
                summaryRow(l10n.filesRemoved, "\(vm.removedCount)")
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

    private func removeSelected() {
        #if APPSTORE
        if storeService.requiresPayment {
            storeService.showPaywall = true
            return
        }
        #endif
        vm.removeSelected()
    }

    private func filterLabel(_ category: FileCategory) -> String {
        switch category {
        case .all: l10n.filterAll
        case .video: l10n.filterVideo
        case .archive: l10n.filterArchive
        case .diskImage: l10n.filterDiskImage
        case .installer: l10n.filterInstaller
        case .vm: l10n.filterVM
        case .other: l10n.filterOther
        }
    }

    private func summaryRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).foregroundStyle(.secondary)
            Spacer()
            Text(value).bold()
        }
        .frame(maxWidth: 300)
    }
}
