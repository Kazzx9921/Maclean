import Foundation
import SwiftUI

@MainActor
final class AppLipoViewModel: ObservableObject {
    static let shared = AppLipoViewModel()

    @Published var phase: AppManagerPhase = .idle
    @Published var apps: [UniversalAppInfo] = []
    @Published var currentAppName: String = ""
    @Published var fileLog: [String] = []
    @Published var progress: Double = 0
    @Published var thinnedCount: Int = 0
    @Published var savedSize: Int64 = 0
    @Published var removingCurrent: Int = 0
    @Published var removingTotal: Int = 0

    private let lipoService = LipoService()

    private init() {}

    var selectedApps: [UniversalAppInfo] {
        apps.filter(\.isSelected)
    }

    var selectedTotalSize: Int64 {
        selectedApps.reduce(0) { $0 + $1.removableArchSize }
    }

    var allSelected: Bool {
        !apps.isEmpty && apps.allSatisfy(\.isSelected)
    }

    func toggleSelectAll() {
        let newValue = !allSelected
        for i in apps.indices {
            apps[i].isSelected = newValue
        }
    }

    func startScan() {
        phase = .scanning
        apps = []
        fileLog = []
        Task {
            let results = await lipoService.scanUniversalApps { [weak self] name in
                self?.currentAppName = name
                if (self?.fileLog.count ?? 0) >= 200 { self?.fileLog.removeFirst() }
                self?.fileLog.append(name)
            }
            apps = results
            phase = .loaded
        }
    }

    func thinSelected() {
        let toThin = selectedApps
        guard !toThin.isEmpty else { return }

        phase = .removing
        progress = 0
        removingCurrent = 0
        removingTotal = toThin.count

        Task {
            var count = 0
            var saved: Int64 = 0

            for (index, app) in toThin.enumerated() {
                progress = Double(index + 1) / Double(toThin.count)
                removingCurrent = index + 1
                currentAppName = app.name

                let success = await lipoService.thinApp(app)
                if success {
                    count += 1
                    saved += app.removableArchSize
                }
            }

            thinnedCount = count
            savedSize = saved
            phase = .done
        }
    }

    func rescan() {
        apps = []
        currentAppName = ""
        fileLog = []
        progress = 0
        thinnedCount = 0
        savedSize = 0
        startScan()
    }
}
