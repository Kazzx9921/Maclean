import Foundation

actor CleanEngine {
    /// Move selected items to trash (reversible)
    func moveToTrash(
        report: DryRunReport,
        progress: @MainActor @Sendable (Double, String) -> Void
    ) async -> CleanSummary {
        let startTime = Date()
        var totalCleaned: Int64 = 0
        var filesRemoved = 0
        var errors: [CleanError] = []
        var trashedItems: [TrashedItem] = []

        let allItems = report.categories.flatMap { $0.items.filter(\.isSelected) }
        let totalCount = allItems.count
        let fm = FileManager.default
        var trashedPaths: [String] = []

        let trashDir = fm.homeDirectoryForCurrentUser
            .appendingPathComponent(".Trash")
            .resolvingSymlinksInPath()
            .path(percentEncoded: false)

        for (index, item) in allItems.enumerated() {
            let pct = Double(index + 1) / Double(max(totalCount, 1))
            await progress(pct, item.relativePath)

            let itemPath = item.path.path(percentEncoded: false)

            // Skip if parent directory was already trashed
            if trashedPaths.contains(where: { itemPath.hasPrefix($0 + "/") }) {
                continue
            }

            // Items already in Trash — record directly, no need to trashItem again
            let resolvedPath = item.path.resolvingSymlinksInPath().path(percentEncoded: false)
            if resolvedPath.hasPrefix(trashDir + "/") {
                trashedItems.append(TrashedItem(originalPath: item.path, trashedPath: item.path, size: item.size))
                totalCleaned += item.size
                filesRemoved += 1
                if item.isDirectory { trashedPaths.append(itemPath) }
                continue
            }

            do {
                var resultURL: NSURL?
                try fm.trashItem(at: item.path, resultingItemURL: &resultURL)
                if let trashed = resultURL as URL? {
                    trashedItems.append(TrashedItem(originalPath: item.path, trashedPath: trashed, size: item.size))
                }
                if item.isDirectory {
                    trashedPaths.append(itemPath)
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
            duration: duration,
            trashedItems: trashedItems
        )
    }

    /// Restore all trashed items to their original locations
    func restore(summary: CleanSummary) async -> Int {
        let fm = FileManager.default
        var restored = 0

        for item in summary.trashedItems {
            // Skip items that were already in trash (originalPath == trashedPath)
            if item.originalPath == item.trashedPath { continue }

            do {
                // Create parent directory if needed
                let parentDir = item.originalPath.deletingLastPathComponent()
                try fm.createDirectory(at: parentDir, withIntermediateDirectories: true)
                try fm.moveItem(at: item.trashedPath, to: item.originalPath)
                restored += 1
            } catch {
                // File may already be gone from trash
            }
        }

        return restored
    }

    /// Permanently delete trashed items (empty them from trash)
    func confirmPermanentDelete(
        summary: CleanSummary,
        progress: @MainActor @Sendable (Double, String) -> Void = { _, _ in }
    ) async -> Int {
        let fm = FileManager.default
        var deleted = 0
        let total = summary.trashedItems.count

        let trashDir = fm.homeDirectoryForCurrentUser
            .appendingPathComponent(".Trash")
            .resolvingSymlinksInPath()
            .path(percentEncoded: false)

        for (index, item) in summary.trashedItems.enumerated() {
            let pct = Double(index + 1) / Double(max(total, 1))
            await progress(pct, item.originalPath.lastPathComponent)

            let resolvedPath = item.trashedPath.resolvingSymlinksInPath().path(percentEncoded: false)
            guard resolvedPath.hasPrefix(trashDir + "/") else { continue }

            do {
                try fm.removeItem(at: item.trashedPath)
                deleted += 1
            } catch {
                // Already gone
            }
        }

        return deleted
    }
}
