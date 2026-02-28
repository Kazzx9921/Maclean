import Foundation

struct ProjectInfo: Identifiable, Sendable {
    let id = UUID()
    let name: String
    let path: URL
    let artifactPath: URL
    let artifactType: String
    let size: Int64
    let lastModified: Date?
    var isSelected: Bool = false
}
