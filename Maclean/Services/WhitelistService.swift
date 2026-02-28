import Foundation

@MainActor
final class WhitelistService: ObservableObject {
    static let shared = WhitelistService()

    @Published private(set) var entries: [WhitelistEntry] = []

    private let fileURL: URL = {
        let dir = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".maclean", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true,
            attributes: [.posixPermissions: 0o700])
        return dir.appendingPathComponent("whitelist.json")
    }()

    private init() {
        load()
    }

    func add(_ entry: WhitelistEntry) {
        guard !entries.contains(where: { $0.path == entry.path }) else { return }
        entries.append(entry)
        save()
    }

    func remove(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func remove(_ entry: WhitelistEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([WhitelistEntry].self, from: data)
        else { return }
        entries = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
        try? FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: fileURL.path(percentEncoded: false))
    }
}
