import Foundation

struct TrashModule: CleanModule {
    let name = "Trash"
    let icon = "trash"

    func scan(onFile: @escaping @Sendable (String) -> Void) async throws -> [CleanItem] {
        let fm = FileManager.default
        let trashURL = fm.homeDirectoryForCurrentUser.appendingPathComponent(".Trash")
        var items: [CleanItem] = []

        onFile(trashURL.path(percentEncoded: false))

        do {
            let contents = try fm.contentsOfDirectory(
                at: trashURL,
                includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey, .totalFileAllocatedSizeKey],
                options: [.skipsSubdirectoryDescendants]
            )

            for url in contents {
                let name = url.lastPathComponent
                if name == ".DS_Store" || name == ".Trashes" { continue }

                onFile(url.path(percentEncoded: false))
                let values = try? url.resourceValues(forKeys: [.isDirectoryKey])
                let isDirectory = values?.isDirectory ?? false
                let size = FileSystemService.trashItemSize(of: url)
                if size > 0 {
                    items.append(CleanItem(path: url, size: size, isDirectory: isDirectory))
                }
            }
        } catch {
            // Permission denied — return empty
        }

        return items.sorted { $0.size > $1.size }
    }
}
