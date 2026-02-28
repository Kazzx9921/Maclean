import Foundation

struct BrowserCacheModule: CleanModule {
    let name = "Browser Cache"
    let icon = "globe"

    private struct BrowserPath {
        let name: String
        let relativePaths: [String]
    }

    private var browsers: [BrowserPath] {
        [
            BrowserPath(name: "Chrome", relativePaths: [
                "Library/Caches/Google/Chrome",
                "Library/Caches/Google/Chrome/Default/Cache",
            ]),
            BrowserPath(name: "Safari", relativePaths: [
                "Library/Caches/com.apple.Safari",
            ]),
            BrowserPath(name: "Firefox", relativePaths: [
                "Library/Caches/Firefox",
            ]),
            BrowserPath(name: "Arc", relativePaths: [
                "Library/Caches/company.thebrowser.Browser",
            ]),
        ]
    }

    func scan(onFile: @escaping @Sendable (String) -> Void) async throws -> [CleanItem] {
        let fm = FileManager.default
        let home = fm.homeDirectoryForCurrentUser
        var items: [CleanItem] = []

        for browser in browsers {
            for relPath in browser.relativePaths {
                let url = home.appendingPathComponent(relPath)
                var isDir: ObjCBool = false
                guard fm.fileExists(atPath: url.path(percentEncoded: false), isDirectory: &isDir) else { continue }

                onFile(url.path(percentEncoded: false))
                let size = FileSystemService.size(of: url)
                if size > 0 {
                    items.append(CleanItem(path: url, size: size, isDirectory: isDir.boolValue))
                }
            }
        }

        return items.sorted { $0.size > $1.size }
    }
}
