import Foundation

struct HomebrewModule: CleanModule {
    let name = "Homebrew"
    let icon = "mug"

    func scan(onFile: @escaping @Sendable (String) -> Void) async throws -> [CleanItem] {
        let fm = FileManager.default
        var items: [CleanItem] = []

        // Find brew cache directory
        let brewPaths = [
            "/opt/homebrew/bin/brew",
            "/usr/local/bin/brew",
        ]

        guard brewPaths.contains(where: { fm.fileExists(atPath: $0) }) else {
            return []
        }

        // Common Homebrew cache locations
        let home = fm.homeDirectoryForCurrentUser
        let cachePaths = [
            home.appendingPathComponent("Library/Caches/Homebrew"),
            URL(fileURLWithPath: "/opt/homebrew/Caches"),
        ]

        for cacheDir in cachePaths {
            guard fm.fileExists(atPath: cacheDir.path(percentEncoded: false)) else { continue }

            onFile(cacheDir.path(percentEncoded: false))

            guard let contents = try? fm.contentsOfDirectory(
                at: cacheDir,
                includingPropertiesForKeys: [.isDirectoryKey],
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
