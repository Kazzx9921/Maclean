import Foundation

struct CleanHistory: Identifiable, Codable, Sendable {
    let id: UUID
    let date: Date
    let totalCleaned: Int64
    let filesRemoved: Int
    let categories: [CategorySummary]

    struct CategorySummary: Codable, Sendable {
        let name: String
        let size: Int64
        let count: Int
    }

    init(date: Date, totalCleaned: Int64, filesRemoved: Int, categories: [CategorySummary]) {
        self.id = UUID()
        self.date = date
        self.totalCleaned = totalCleaned
        self.filesRemoved = filesRemoved
        self.categories = categories
    }
}
