import Foundation

actor AppScannerService {
    private let threshold: TimeInterval = 90 * 24 * 60 * 60 // 90 days

    func scan(
        onProgress: @MainActor @Sendable (String) -> Void
    ) async -> [AppInfo] {
        let fm = FileManager.default
        let home = fm.homeDirectoryForCurrentUser

        var appURLs: [URL] = []
        let systemApps = URL(fileURLWithPath: "/Applications")
        let userApps = home.appendingPathComponent("Applications")

        if let contents = try? fm.contentsOfDirectory(at: systemApps, includingPropertiesForKeys: nil) {
            appURLs.append(contentsOf: contents.filter { $0.pathExtension == "app" })
        }
        if let contents = try? fm.contentsOfDirectory(at: userApps, includingPropertiesForKeys: nil) {
            appURLs.append(contentsOf: contents.filter { $0.pathExtension == "app" })
        }

        var results: [AppInfo] = []

        for appURL in appURLs {
            let appName = appURL.deletingPathExtension().lastPathComponent
            await onProgress(appName)

            guard let bundle = Bundle(url: appURL),
                  let bundleID = bundle.bundleIdentifier else { continue }

            // Skip system apps
            if bundleID.hasPrefix("com.apple.") { continue }

            let lastUsed = lastUsedDate(for: appURL)

            // Only include apps unused for > 90 days
            if let lastUsed {
                if Date().timeIntervalSince(lastUsed) < threshold { continue }
            }
            // If lastUsed is nil, the app was never opened — include it

            let appSize = FileSystemService.directorySize(appURL)
            let associated = findAssociatedPaths(appName: appName, bundleID: bundleID)

            let info = AppInfo(
                name: appName,
                bundleID: bundleID,
                path: appURL,
                size: appSize,
                lastUsedDate: lastUsed,
                associatedPaths: associated
            )
            results.append(info)
        }

        // Sort by size descending
        results.sort { $0.totalSize > $1.totalSize }
        return results
    }

    private func lastUsedDate(for appURL: URL) -> Date? {
        let item = NSMetadataItem(url: appURL)
        if let date = item?.value(forAttribute: "kMDItemLastUsedDate") as? Date {
            return date
        }

        // Fallback: check content access date
        let resourceValues = try? appURL.resourceValues(forKeys: [.contentAccessDateKey])
        return resourceValues?.contentAccessDate
    }

    private func findAssociatedPaths(appName: String, bundleID: String) -> [AssociatedPath] {
        let fm = FileManager.default
        let home = fm.homeDirectoryForCurrentUser
        let library = home.appendingPathComponent("Library")
        var paths: [AssociatedPath] = []

        // Application Support
        let appSupport = library.appendingPathComponent("Application Support").appendingPathComponent(appName)
        if fm.fileExists(atPath: appSupport.path(percentEncoded: false)) {
            let size = FileSystemService.directorySize(appSupport)
            paths.append(AssociatedPath(url: appSupport, size: size, kind: .appSupport))
        }

        // Caches
        let caches = library.appendingPathComponent("Caches").appendingPathComponent(bundleID)
        if fm.fileExists(atPath: caches.path(percentEncoded: false)) {
            let size = FileSystemService.directorySize(caches)
            paths.append(AssociatedPath(url: caches, size: size, kind: .caches))
        }

        // Preferences
        let prefs = library.appendingPathComponent("Preferences").appendingPathComponent("\(bundleID).plist")
        if fm.fileExists(atPath: prefs.path(percentEncoded: false)) {
            let size = FileSystemService.fileSize(prefs)
            paths.append(AssociatedPath(url: prefs, size: size, kind: .preferences))
        }

        return paths
    }
}
