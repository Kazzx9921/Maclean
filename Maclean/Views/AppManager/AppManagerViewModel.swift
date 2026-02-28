import Foundation
import SwiftUI

enum AppManagerPhase: Equatable {
    case idle
    case scanning
    case loaded
    case removing
    case done
}

@MainActor
final class AppManagerViewModel: ObservableObject {
    static let shared = AppManagerViewModel()

    @Published var phase: AppManagerPhase = .idle
    @Published var apps: [AppInfo] = []
    @Published var currentAppName: String = ""
    @Published var fileLog: [String] = []
    @Published var progress: Double = 0
    @Published var removedCount: Int = 0
    @Published var removedSize: Int64 = 0
    @Published var removingCurrent: Int = 0
    @Published var removingTotal: Int = 0

    private let scanner = AppScannerService()
    private let cleanEngine = CleanEngine()

    private init() {}

    var selectedApps: [AppInfo] {
        apps.filter(\.isSelected)
    }

    var selectedTotalSize: Int64 {
        selectedApps.reduce(0) { $0 + $1.totalSize }
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
            let results = await scanner.scan { [weak self] name in
                self?.currentAppName = name
                if (self?.fileLog.count ?? 0) >= 200 { self?.fileLog.removeFirst() }
                self?.fileLog.append(name)
            }
            apps = results
            phase = .loaded
        }
    }

    func removeSelected() {
        let toRemove = selectedApps
        guard !toRemove.isEmpty else { return }

        phase = .removing
        progress = 0
        removingCurrent = 0

        Task {
            // Build CleanItems from selected apps
            var items: [CleanItem] = []
            for app in toRemove {
                items.append(CleanItem(path: app.path, size: app.size, isDirectory: true))
                if app.includeAssociatedData {
                    for assoc in app.associatedPaths {
                        items.append(CleanItem(
                            path: assoc.url,
                            size: assoc.size,
                            isDirectory: assoc.kind != .preferences
                        ))
                    }
                }
            }

            removingTotal = items.count

            let category = CategoryResult(category: "Apps", icon: "app.badge.checkmark", items: items)
            let report = DryRunReport(categories: [category])

            let summary = await cleanEngine.moveToTrash(report: report) { [weak self] pct, file in
                self?.progress = pct
                self?.removingCurrent = Int(pct * Double(self?.removingTotal ?? 0))
                self?.currentAppName = file
            }

            removedCount = summary.filesRemoved
            removedSize = summary.totalCleaned
            phase = .done
        }
    }

    func rescan() {
        apps = []
        currentAppName = ""
        fileLog = []
        progress = 0
        removedCount = 0
        removedSize = 0
        startScan()
    }
}
