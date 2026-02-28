import Foundation

struct CleanSummary: Sendable {
    let totalCleaned: Int64
    let filesRemoved: Int
    let errors: [CleanError]
    let duration: TimeInterval
    let completedAt: Date
    let trashedItems: [TrashedItem]

    init(totalCleaned: Int64, filesRemoved: Int, errors: [CleanError], duration: TimeInterval, trashedItems: [TrashedItem] = []) {
        self.totalCleaned = totalCleaned
        self.filesRemoved = filesRemoved
        self.errors = errors
        self.duration = duration
        self.completedAt = Date()
        self.trashedItems = trashedItems
    }
}

struct CleanError: Identifiable, Sendable {
    let id = UUID()
    let path: String
    let message: String
}

struct TrashedItem: Identifiable, Sendable {
    let id = UUID()
    let originalPath: URL
    let trashedPath: URL
    let size: Int64
}
