import Foundation

actor ScanEngine {
    private let modules: [CleanModule] = [
        SystemCacheModule(),
        SystemLogModule(),
        BrowserCacheModule(),
        XcodeModule(),
        HomebrewModule(),
        DevToolsCacheModule(),
        AppCacheModule(),
        InstallerModule(),
        IOSBackupModule(),
        TrashModule(),
    ]

    func scan(
        whitelist: [WhitelistEntry],
        progress: @escaping @MainActor @Sendable (String) -> Void
    ) async throws -> [CategoryResult] {
        try await withThrowingTaskGroup(of: CategoryResult.self) { group in
            for module in modules {
                group.addTask {
                    let items = try await module.scan { filePath in
                        Task { @MainActor in
                            progress(filePath)
                        }
                    }
                    let filtered = items.filter { !FileSystemService.isWhitelisted($0.path, entries: whitelist) }
                    return CategoryResult(category: module.name, icon: module.icon, items: filtered)
                }
            }

            var results: [CategoryResult] = []
            for try await result in group {
                if !result.items.isEmpty {
                    results.append(result)
                }
            }

            // Deduplicate: remove items whose path appears in an earlier (larger) category
            var seenPaths = Set<String>()
            var deduped: [CategoryResult] = []
            let sorted = results.sorted { $0.totalSize > $1.totalSize }
            for var category in sorted {
                category.items = category.items.filter { item in
                    let path = item.path.path(percentEncoded: false)
                    // Also skip if a parent directory is already claimed
                    let dominated = seenPaths.contains(where: { path.hasPrefix($0 + "/") })
                    if seenPaths.contains(path) || dominated { return false }
                    seenPaths.insert(path)
                    return true
                }
                if !category.items.isEmpty {
                    deduped.append(category)
                }
            }
            return deduped
        }
    }
}
