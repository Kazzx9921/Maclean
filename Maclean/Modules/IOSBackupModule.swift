import Foundation

struct IOSBackupModule: CleanModule {
    let name = "iOS Backups"
    let icon = "iphone"

    func scan(onFile: @escaping @Sendable (String) -> Void) async throws -> [CleanItem] {
        let fm = FileManager.default
        let home = fm.homeDirectoryForCurrentUser
        let backupDir = home.appendingPathComponent("Library/Application Support/MobileSync/Backup")

        guard fm.fileExists(atPath: backupDir.path(percentEncoded: false)) else { return [] }

        guard let contents = try? fm.contentsOfDirectory(
            at: backupDir,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) else { return [] }

        var items: [CleanItem] = []

        for url in contents {
            let values = try? url.resourceValues(forKeys: [.isDirectoryKey])
            guard values?.isDirectory == true else { continue }

            onFile(url.path(percentEncoded: false))
            let size = FileSystemService.directorySize(url)
            if size > 0 {
                items.append(CleanItem(path: url, size: size, isDirectory: true))
            }
        }

        return items.sorted { $0.size > $1.size }
    }
}
