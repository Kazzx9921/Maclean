import Foundation

@MainActor
final class HistoryService: ObservableObject {
    static let shared = HistoryService()

    @Published private(set) var entries: [CleanHistory] = []

    private let fileURL: URL = {
        let dir = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".maclean", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true,
            attributes: [.posixPermissions: 0o700])
        return dir.appendingPathComponent("history.json")
    }()

    private init() {
        load()
    }

    func add(_ entry: CleanHistory) {
        entries.insert(entry, at: 0)
        save()
    }

    func remove(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func clearAll() {
        entries.removeAll()
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([CleanHistory].self, from: data)
        else { return }
        entries = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
        try? FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: fileURL.path(percentEncoded: false))
    }
}
