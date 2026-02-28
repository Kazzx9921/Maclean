import Foundation

actor CleanEngine {
    /// Permanently delete selected items
    func deleteItems(
        report: DryRunReport,
        progress: @MainActor @Sendable (Double, String) -> Void
    ) async -> CleanSummary {
        let startTime = Date()
        var totalCleaned: Int64 = 0
        var filesRemoved = 0
        var errors: [CleanError] = []

        let allItems = report.categories.flatMap { $0.items.filter(\.isSelected) }
        let totalCount = allItems.count
        let fm = FileManager.default
        var deletedPaths: [String] = []

        for (index, item) in allItems.enumerated() {
            let pct = Double(index + 1) / Double(max(totalCount, 1))
            await progress(pct, item.relativePath)

            let itemPath = item.path.path(percentEncoded: false)

            // Skip if parent directory was already deleted
            if deletedPaths.contains(where: { itemPath.hasPrefix($0 + "/") }) {
                continue
            }

            do {
                try fm.removeItem(at: item.path)
                if item.isDirectory {
                    deletedPaths.append(itemPath)
                }
                totalCleaned += item.size
                filesRemoved += 1
            } catch {
                errors.append(CleanError(path: item.relativePath, message: error.localizedDescription))
            }
        }

        let duration = Date().timeIntervalSince(startTime)
        return CleanSummary(
            totalCleaned: totalCleaned,
            filesRemoved: filesRemoved,
            errors: errors,
            duration: duration
        )
    }
}
