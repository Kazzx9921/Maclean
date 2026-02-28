import Foundation

struct CleanSummary: Sendable {
    let totalCleaned: Int64
    let filesRemoved: Int
    let errors: [CleanError]
    let duration: TimeInterval
    let completedAt: Date

    init(totalCleaned: Int64, filesRemoved: Int, errors: [CleanError], duration: TimeInterval) {
        self.totalCleaned = totalCleaned
        self.filesRemoved = filesRemoved
        self.errors = errors
        self.duration = duration
        self.completedAt = Date()
    }
}

struct CleanError: Identifiable, Sendable {
    let id = UUID()
    let path: String
    let message: String
}
