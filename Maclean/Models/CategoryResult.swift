import Foundation

struct CategoryResult: Identifiable, Sendable {
    let id: UUID
    let category: String
    let icon: String
    var items: [CleanItem]

    var totalSize: Int64 {
        items.filter(\.isSelected).reduce(0) { $0 + $1.size }
    }

    var selectedCount: Int {
        items.filter(\.isSelected).count
    }

    init(category: String, icon: String, items: [CleanItem]) {
        self.id = UUID()
        self.category = category
        self.icon = icon
        self.items = items
    }
}
