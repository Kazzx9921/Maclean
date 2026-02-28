import Foundation

struct AssociatedPath: Identifiable, Sendable {
    let id = UUID()
    let url: URL
    let size: Int64
    let kind: Kind

    enum Kind: String, Sendable {
        case appSupport = "Application Support"
        case caches = "Caches"
        case preferences = "Preferences"
    }

    var relativePath: String {
        url.path(percentEncoded: false)
            .replacingOccurrences(
                of: FileManager.default.homeDirectoryForCurrentUser.path(percentEncoded: false),
                with: "~/"
            )
    }
}

struct AppInfo: Identifiable, Sendable {
    let id = UUID()
    let name: String
    let bundleID: String
    let path: URL
    let size: Int64
    let lastUsedDate: Date?
    let associatedPaths: [AssociatedPath]

    var isSelected: Bool = false
    var includeAssociatedData: Bool = true

    var daysSinceLastUsed: Int? {
        guard let lastUsedDate else { return nil }
        return Calendar.current.dateComponents([.day], from: lastUsedDate, to: Date()).day
    }

    var totalAssociatedSize: Int64 {
        associatedPaths.reduce(0) { $0 + $1.size }
    }

    var totalSize: Int64 {
        size + (includeAssociatedData ? totalAssociatedSize : 0)
    }
}
