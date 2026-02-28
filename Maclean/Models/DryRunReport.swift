import Foundation

struct DryRunReport: Sendable {
    let categories: [CategoryResult]
    let generatedAt: Date

    var totalSize: Int64 {
        categories.reduce(0) { $0 + $1.totalSize }
    }

    var totalFiles: Int {
        categories.reduce(0) { $0 + $1.selectedCount }
    }

    init(categories: [CategoryResult]) {
        self.categories = categories
        self.generatedAt = Date()
    }
}
