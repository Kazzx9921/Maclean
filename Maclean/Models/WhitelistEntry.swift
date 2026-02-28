import Foundation

struct WhitelistEntry: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    let path: String
    let note: String
    let addedAt: Date

    init(path: String, note: String = "") {
        self.id = UUID()
        self.path = path
        self.note = note
        self.addedAt = Date()
    }
}
