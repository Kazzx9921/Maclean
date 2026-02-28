import Foundation

struct SystemCacheModule: CleanModule {
    let name = "System Cache"
    let icon = "folder.badge.gearshape"

    func scan(onFile: @escaping @Sendable (String) -> Void) async throws -> [CleanItem] {
        let fm = FileManager.default
        let home = fm.homeDirectoryForCurrentUser
        var items: [CleanItem] = []

        let cacheDirs = [
            home.appendingPathComponent("Library/Caches"),
            home.appendingPathComponent(".cache"),
        ]

        for cacheDir in cacheDirs {
            guard let contents = try? fm.contentsOfDirectory(
                at: cacheDir,
                includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey],
                options: [.skipsHiddenFiles]
            ) else { continue }

            for url in contents {
                onFile(url.path(percentEncoded: false))
                let values = try? url.resourceValues(forKeys: [.isDirectoryKey])
                let isDir = values?.isDirectory ?? false
                let size = FileSystemService.size(of: url)
                if size > 0 {
                    items.append(CleanItem(path: url, size: size, isDirectory: isDir))
                }
            }
        }

        return items.sorted { $0.size > $1.size }
    }
}
