import Foundation

struct SystemLogModule: CleanModule {
    let name = "System Logs"
    let icon = "doc.text"

    func scan(onFile: @escaping @Sendable (String) -> Void) async throws -> [CleanItem] {
        let fm = FileManager.default
        let home = fm.homeDirectoryForCurrentUser
        var items: [CleanItem] = []

        let logDirs = [
            home.appendingPathComponent("Library/Logs"),
        ]

        for logDir in logDirs {
            guard let contents = try? fm.contentsOfDirectory(
                at: logDir,
                includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey],
                options: []
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
