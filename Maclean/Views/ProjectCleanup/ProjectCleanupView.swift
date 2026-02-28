import SwiftUI

struct ProjectCleanupView: View {
    @EnvironmentObject var vm: ProjectCleanupViewModel
    @EnvironmentObject var l10n: L10n

    var body: some View {
        VStack(spacing: 0) {
            switch vm.phase {
            case .idle, .scanning:
                scanningView
            case .loaded:
                if vm.projects.isEmpty {
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
        .navigationTitle(l10n.projectCleanup)
        .task { if vm.phase == .idle { vm.startScan() } }
    }

    private var scanningView: some View {
        ScanningAnimationView(title: l10n.scanningProjects, fileLog: vm.fileLog)
            .padding()
    }

    private var emptyView: some View {
        ContentUnavailableView(
            l10n.noArtifacts,
            systemImage: "hammer",
            description: Text(l10n.noArtifactsDesc)
        )
    }

    private var loadedView: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(Array(vm.projects.enumerated()), id: \.element.id) { index, project in
                        ProjectInfoRow(
                            project: Binding(
                                get: { vm.projects[index] },
                                set: { vm.projects[index] = $0 }
                            )
                        )
                    }
                }
                .padding()
            }

            bottomBar
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

            Text(l10n.itemsSummary(vm.selectedProjects.count, FileSize.formatted(vm.selectedTotalSize)))
                .foregroundStyle(.secondary)

            Spacer()

            Button(action: removeSelected) {
                Text(l10n.cleanProjects)
            }
            .glassProminentButtonStyle()
            .tint(.red)
            .controlSize(.large)
            .disabled(vm.selectedProjects.isEmpty)
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

            Text(l10n.projectsCleaned)
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
        vm.removeSelected()
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
