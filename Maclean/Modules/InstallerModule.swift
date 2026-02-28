import Foundation

struct InstallerModule: CleanModule {
    let name = "Installers"
    let icon = "shippingbox"

    private let extensions: Set<String> = ["dmg", "pkg", "iso", "xip"]

    private var scanDirectories: [String] {
        [
            "Downloads",
            "Desktop",
        ]
    }

    func scan(onFile: @escaping @Sendable (String) -> Void) async throws -> [CleanItem] {
        let fm = FileManager.default
        let home = fm.homeDirectoryForCurrentUser
        var items: [CleanItem] = []

        for dir in scanDirectories {
            let dirURL = home.appendingPathComponent(dir)
            guard let contents = try? fm.contentsOfDirectory(
                at: dirURL,
                includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey],
                options: [.skipsHiddenFiles]
            ) else { continue }

            for url in contents {
                let ext = url.pathExtension.lowercased()
                guard extensions.contains(ext) else { continue }

                onFile(url.path(percentEncoded: false))
                let size = FileSystemService.fileSize(url)
                if size > 0 {
                    items.append(CleanItem(path: url, size: size, isDirectory: false))
                }
            }
        }

        return items.sorted { $0.size > $1.size }
    }
}
