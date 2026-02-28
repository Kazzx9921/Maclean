import Foundation

actor DiskAnalyzerService {
    private let minimumSize: Int64 = 100 * 1024 * 1024 // 100 MB

    func scan(
        root: URL,
        onProgress: @MainActor @Sendable (Int, String) -> Void
    ) async -> [LargeFileInfo] {
        let fm = FileManager.default
        var results: [LargeFileInfo] = []

        // Collect file URLs synchronously to avoid async iterator issue
        let collected = collectLargeFiles(root: root, fm: fm)

        for (index, entry) in collected.enumerated() {
            if index % 500 == 0 {
                await onProgress(index, entry.url.path(percentEncoded: false))
            }
            results.append(entry.info)
        }

        return results.sorted { $0.size > $1.size }
    }

    private struct FileEntry: Sendable {
        let url: URL
        let info: LargeFileInfo
    }

    private func collectLargeFiles(root: URL, fm: FileManager) -> [FileEntry] {
        guard let enumerator = fm.enumerator(
            at: root,
            includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey, .contentModificationDateKey],
            options: [.skipsPackageDescendants]
        ) else { return [] }

        var entries: [FileEntry] = []

        while let obj = enumerator.nextObject() {
            guard let url = obj as? URL else { continue }
            let values = try? url.resourceValues(forKeys: [.isDirectoryKey, .fileSizeKey, .contentModificationDateKey])

            if values?.isDirectory == true {
                if url.lastPathComponent == "Library" && url.deletingLastPathComponent() == root {
                    enumerator.skipDescendants()
                }
                continue
            }

            let size = Int64(values?.fileSize ?? 0)
            guard size >= minimumSize else { continue }

            let modDate = values?.contentModificationDate
            let category = LargeFileInfo.categorize(url)

            entries.append(FileEntry(
                url: url,
                info: LargeFileInfo(path: url, size: size, modificationDate: modDate, category: category)
            ))
        }

        return entries
    }
}
