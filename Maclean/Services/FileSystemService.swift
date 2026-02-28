import Foundation

struct FileSystemService: Sendable {
    private static let protectedPaths: Set<String> = [
        "/System",
        "/Library",
        "/usr",
        "/bin",
        "/sbin",
        "/private",
        "/Applications",
    ]

    static func isPathSafe(_ url: URL) -> Bool {
        let resolved = url.resolvingSymlinksInPath()
        let path = resolved.path(percentEncoded: false)
        var home = FileManager.default.homeDirectoryForCurrentUser
            .resolvingSymlinksInPath()
            .path(percentEncoded: false)
        if home.hasSuffix("/") { home = String(home.dropLast()) }

        // Must be under home directory
        guard path == home || path.hasPrefix(home + "/") else { return false }

        // Block critical user directories
        let blocked = [
            home + "/Desktop",
            home + "/Documents",
            home + "/Downloads",
            home + "/Pictures",
            home + "/Movies",
            home + "/Music",
        ]
        for b in blocked {
            if path == b || path == b + "/" { return false }
        }

        return true
    }

    static func isWhitelisted(_ url: URL, entries: [WhitelistEntry]) -> Bool {
        let resolved = url.resolvingSymlinksInPath()
        let path = resolved.path(percentEncoded: false)
        return entries.contains { entry in
            let normalized = (entry.path as NSString).standardizingPath
            return path == normalized || path.hasPrefix(normalized + "/")
        }
    }

    static func size(of url: URL) -> Int64 {
        let fm = FileManager.default
        var isDir: ObjCBool = false

        guard fm.fileExists(atPath: url.path(percentEncoded: false), isDirectory: &isDir) else {
            return 0
        }

        if isDir.boolValue {
            return directorySize(url)
        } else {
            return fileSize(url)
        }
    }

    static func fileSize(_ url: URL) -> Int64 {
        let values = try? url.resourceValues(forKeys: [.fileSizeKey])
        return Int64(values?.fileSize ?? 0)
    }

    static func directorySize(_ url: URL) -> Int64 {
        let fm = FileManager.default
        guard let enumerator = fm.enumerator(
            at: url,
            includingPropertiesForKeys: [.totalFileAllocatedSizeKey, .isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) else { return 0 }

        var total: Int64 = 0
        for case let fileURL as URL in enumerator {
            let values = try? fileURL.resourceValues(forKeys: [.totalFileAllocatedSizeKey, .isDirectoryKey])
            if values?.isDirectory == false {
                total += Int64(values?.totalFileAllocatedSize ?? 0)
            }
        }
        return total
    }

    /// Size calculation that includes hidden files (for Trash)
    static func trashItemSize(of url: URL) -> Int64 {
        let fm = FileManager.default
        var isDir: ObjCBool = false

        guard fm.fileExists(atPath: url.path(percentEncoded: false), isDirectory: &isDir) else {
            return 0
        }

        if !isDir.boolValue {
            return fileSize(url)
        }

        guard let enumerator = fm.enumerator(
            at: url,
            includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey],
            options: []
        ) else { return 0 }

        var total: Int64 = 0
        for case let fileURL as URL in enumerator {
            let values = try? fileURL.resourceValues(forKeys: [.fileSizeKey, .isDirectoryKey])
            if values?.isDirectory == false {
                total += Int64(values?.fileSize ?? 0)
            }
        }
        return total
    }

    static func removeItem(at url: URL) throws {
        guard isPathSafe(url) else {
            throw CleanServiceError.unsafePath(url.path(percentEncoded: false))
        }
        try FileManager.default.removeItem(at: url)
    }
}

enum CleanServiceError: LocalizedError {
    case unsafePath(String)
    case scanFailed(String)

    var errorDescription: String? {
        switch self {
        case .unsafePath(let path): "Unsafe path blocked: \(path)"
        case .scanFailed(let msg): "Scan failed: \(msg)"
        }
    }
}
