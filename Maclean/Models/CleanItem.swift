import Foundation

struct CleanItem: Identifiable, Hashable, Sendable {
    let id: UUID
    let path: URL
    let size: Int64
    let isDirectory: Bool
    var isSelected: Bool

    var name: String {
        path.lastPathComponent
    }

    var relativePath: String {
        path.path(percentEncoded: false)
            .replacingOccurrences(of: FileManager.default.homeDirectoryForCurrentUser.path(percentEncoded: false), with: "~/")
    }

    init(path: URL, size: Int64, isDirectory: Bool, isSelected: Bool = true) {
        self.id = UUID()
        self.path = path
        self.size = size
        self.isDirectory = isDirectory
        self.isSelected = isSelected
    }
}
