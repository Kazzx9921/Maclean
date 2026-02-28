import Foundation
import SwiftUI

@MainActor
final class ProjectCleanupViewModel: ObservableObject {
    static let shared = ProjectCleanupViewModel()

    @Published var phase: AppManagerPhase = .idle
    @Published var projects: [ProjectInfo] = []
    @Published var currentPath: String = ""
    @Published var fileLog: [String] = []
    @Published var progress: Double = 0
    @Published var removedCount: Int = 0
    @Published var removedSize: Int64 = 0
    @Published var removingCurrent: Int = 0
    @Published var removingTotal: Int = 0
    private var scanRootsData: Data {
        get { UserDefaults.standard.data(forKey: "projectScanRoots") ?? Data() }
        set { UserDefaults.standard.set(newValue, forKey: "projectScanRoots") }
    }

    private let scanner = ProjectScannerService()

    private init() {}

    var scanRoots: [URL] {
        get {
            (try? JSONDecoder().decode([String].self, from: scanRootsData))?.map { URL(fileURLWithPath: $0) } ?? defaultRoots
        }
        set {
            scanRootsData = (try? JSONEncoder().encode(newValue.map(\.path))) ?? Data()
        }
    }

    private var defaultRoots: [URL] {
        let home = FileManager.default.homeDirectoryForCurrentUser
        let candidates = ["Developer", "Projects", "Documents", "GitHub", "dev"]
        return candidates
            .map { home.appendingPathComponent($0) }
            .filter { FileManager.default.fileExists(atPath: $0.path(percentEncoded: false)) }
    }

    var selectedProjects: [ProjectInfo] {
        projects.filter(\.isSelected)
    }

    var selectedTotalSize: Int64 {
        selectedProjects.reduce(0) { $0 + $1.size }
    }

    var allSelected: Bool {
        !projects.isEmpty && projects.allSatisfy(\.isSelected)
    }

    func toggleSelectAll() {
        let newValue = !allSelected
        for i in projects.indices {
            projects[i].isSelected = newValue
        }
    }

    func addRoot(_ url: URL) {
        var roots = scanRoots
        if !roots.contains(url) {
            roots.append(url)
            scanRoots = roots
        }
    }

    func startScan() {
        phase = .scanning
        projects = []
        fileLog = []
        Task {
            let home = FileManager.default.homeDirectoryForCurrentUser.path(percentEncoded: false)
            let results = await scanner.scan(roots: scanRoots) { [weak self] path in
                self?.currentPath = path
                if (self?.fileLog.count ?? 0) >= 200 {
                    self?.fileLog.removeFirst()
                }
                self?.fileLog.append(path.replacingOccurrences(of: home, with: "~/"))
            }
            projects = results
            phase = .loaded
        }
    }

    func removeSelected() {
        let toRemove = selectedProjects
        guard !toRemove.isEmpty else { return }

        phase = .removing
        progress = 0
        removingCurrent = 0
        removingTotal = toRemove.count

        Task {
            let fm = FileManager.default
            var totalCleaned: Int64 = 0
            var count = 0

            for (index, project) in toRemove.enumerated() {
                progress = Double(index + 1) / Double(toRemove.count)
                removingCurrent = index + 1
                currentPath = project.artifactPath.lastPathComponent
                await Task.yield()

                let resolved = project.artifactPath.resolvingSymlinksInPath()
                guard FileSystemService.isPathSafe(resolved) else { continue }

                do {
                    try fm.removeItem(at: resolved)
                    totalCleaned += project.size
                    count += 1
                } catch {
                    // Skip failures
                }
            }

            removedCount = count
            removedSize = totalCleaned
            phase = .done
        }
    }

    func rescan() {
        projects = []
        currentPath = ""
        fileLog = []
        progress = 0
        removedCount = 0
        removedSize = 0
        startScan()
    }
}
