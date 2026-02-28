import Foundation

struct XcodeModule: CleanModule {
    let name = "Xcode"
    let icon = "hammer"

    private let targets: [(String, String)] = [
        ("Library/Developer/Xcode/DerivedData", "DerivedData"),
        ("Library/Developer/Xcode/Archives", "Archives"),
        ("Library/Developer/Xcode/iOS Device Logs", "iOS Device Logs"),
        ("Library/Developer/CoreSimulator/Caches", "Simulator Caches"),
        ("Library/Caches/com.apple.dt.Xcode", "Xcode Cache"),
        ("Library/Developer/Xcode/Products", "Build Products"),
        ("Library/Logs/CoreSimulator", "Simulator Logs"),
    ]

    func scan(onFile: @escaping @Sendable (String) -> Void) async throws -> [CleanItem] {
        let fm = FileManager.default
        let home = fm.homeDirectoryForCurrentUser
        var items: [CleanItem] = []

        for (relPath, _) in targets {
            let url = home.appendingPathComponent(relPath)
            guard fm.fileExists(atPath: url.path(percentEncoded: false)) else { continue }

            onFile(url.path(percentEncoded: false))

            // For DerivedData and Archives, list sub-items individually
            if relPath.hasSuffix("DerivedData") || relPath.hasSuffix("Archives") {
                guard let contents = try? fm.contentsOfDirectory(
                    at: url,
                    includingPropertiesForKeys: [.isDirectoryKey],
                    options: [.skipsHiddenFiles]
                ) else { continue }

                for child in contents {
                    onFile(child.path(percentEncoded: false))
                    let size = FileSystemService.directorySize(child)
                    if size > 0 {
                        items.append(CleanItem(path: child, size: size, isDirectory: true))
                    }
                }
            } else {
                let size = FileSystemService.size(of: url)
                if size > 0 {
                    items.append(CleanItem(path: url, size: size, isDirectory: true))
                }
            }
        }

        return items.sorted { $0.size > $1.size }
    }
}
