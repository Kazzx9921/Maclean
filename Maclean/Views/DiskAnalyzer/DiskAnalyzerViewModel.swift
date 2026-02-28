import Foundation
import SwiftUI

@MainActor
final class DiskAnalyzerViewModel: ObservableObject {
    static let shared = DiskAnalyzerViewModel()

    @Published var phase: AppManagerPhase = .idle
    @Published var files: [LargeFileInfo] = []
    @Published var currentPath: String = ""
    @Published var fileLog: [String] = []
    @Published var scannedCount: Int = 0
    @Published var progress: Double = 0
    @Published var removedCount: Int = 0
    @Published var removedSize: Int64 = 0
    @Published var removingCurrent: Int = 0
    @Published var removingTotal: Int = 0
    @Published var selectedFilter: FileCategory = .all

    private let analyzer = DiskAnalyzerService()
    private let cleanEngine = CleanEngine()

    private init() {}

    var filteredFiles: [LargeFileInfo] {
        if selectedFilter == .all { return files }
        return files.filter { $0.category == selectedFilter }
    }

    var selectedFiles: [LargeFileInfo] {
        filteredFiles.filter(\.isSelected)
    }

    var selectedTotalSize: Int64 {
        selectedFiles.reduce(0) { $0 + $1.size }
    }

    var allSelected: Bool {
        let visible = filteredFiles
        return !visible.isEmpty && visible.allSatisfy(\.isSelected)
    }

    func toggleSelectAll() {
        let newValue = !allSelected
        let visibleIDs = Set(filteredFiles.map(\.id))
        for i in files.indices where visibleIDs.contains(files[i].id) {
            files[i].isSelected = newValue
        }
    }

    func startScan() {
        phase = .scanning
        files = []
        fileLog = []
        scannedCount = 0
        let home = FileManager.default.homeDirectoryForCurrentUser
        let homePath = home.path(percentEncoded: false)
        Task {
            let results = await analyzer.scan(root: home) { [weak self] count, path in
                self?.scannedCount = count
                self?.currentPath = path
                if (self?.fileLog.count ?? 0) >= 200 { self?.fileLog.removeFirst() }
                self?.fileLog.append(path.replacingOccurrences(of: homePath, with: "~/"))
            }
            files = results
            phase = .loaded
        }
    }

    func removeSelected() {
        let toRemove = selectedFiles
        guard !toRemove.isEmpty else { return }

        phase = .removing
        progress = 0
        removingCurrent = 0
        removingTotal = toRemove.count

        Task {
            var items: [CleanItem] = toRemove.map {
                CleanItem(path: $0.path, size: $0.size, isDirectory: false)
            }
            // Ensure all selected
            for i in items.indices { items[i].isSelected = true }

            let category = CategoryResult(category: "Large Files", icon: "doc.fill", items: items)
            let report = DryRunReport(categories: [category])

            let summary = await cleanEngine.moveToTrash(report: report) { [weak self] pct, file in
                self?.progress = pct
                self?.removingCurrent = Int(pct * Double(self?.removingTotal ?? 0))
                self?.currentPath = file
            }

            removedCount = summary.filesRemoved
            removedSize = summary.totalCleaned
            phase = .done
        }
    }

    func rescan() {
        files = []
        currentPath = ""
        fileLog = []
        progress = 0
        scannedCount = 0
        removedCount = 0
        removedSize = 0
        selectedFilter = .all
        startScan()
    }
}
