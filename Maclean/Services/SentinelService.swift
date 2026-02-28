import Foundation
import UserNotifications

@MainActor
final class SentinelService: ObservableObject {
    static let shared = SentinelService()

    @Published var isEnabled: Bool = false {
        didSet {
            if isEnabled { startWatching() } else { stopWatching() }
        }
    }
    @Published var lastDetectedApp: String?

    private var source: DispatchSourceFileSystemObject?
    private var trashFD: Int32 = -1

    private init() {}

    private func startWatching() {
        stopWatching()
        requestNotificationPermission()

        let trashPath = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".Trash")
            .path(percentEncoded: false)

        trashFD = open(trashPath, O_EVTONLY)
        guard trashFD >= 0 else { return }

        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: trashFD,
            eventMask: .write,
            queue: .global(qos: .utility)
        )

        source.setEventHandler { [weak self] in
            Task { @MainActor in
                self?.checkTrashForApps()
            }
        }

        source.setCancelHandler { [weak self] in
            if let fd = self?.trashFD, fd >= 0 {
                close(fd)
            }
        }

        self.source = source
        source.resume()
    }

    private func stopWatching() {
        source?.cancel()
        source = nil
        trashFD = -1
    }

    private func checkTrashForApps() {
        let fm = FileManager.default
        let trashURL = fm.homeDirectoryForCurrentUser.appendingPathComponent(".Trash")

        guard let contents = try? fm.contentsOfDirectory(
            at: trashURL,
            includingPropertiesForKeys: [.creationDateKey],
            options: [.skipsHiddenFiles]
        ) else { return }

        // Look for recently trashed .app bundles
        let recentThreshold = Date().addingTimeInterval(-30) // Last 30 seconds

        for url in contents {
            guard url.pathExtension == "app" else { continue }
            let attrs = try? url.resourceValues(forKeys: [.creationDateKey])
            if let created = attrs?.creationDate, created > recentThreshold {
                let appName = url.deletingPathExtension().lastPathComponent
                lastDetectedApp = appName
                sendNotification(appName: appName)
                break
            }
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    private func sendNotification(appName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Maclean"
        content.body = String(
            format: "%@ was moved to Trash. Open Maclean to clean leftover data.",
            appName
        )
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "sentinel-\(UUID().uuidString)",
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)
    }
}
