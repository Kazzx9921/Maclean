import Foundation

struct AppCacheModule: CleanModule {
    let name = "App Cache"
    let icon = "app.dashed"

    private struct AppCachePath {
        let appName: String
        let relativePaths: [String]
    }

    private var appCaches: [AppCachePath] {
        [
            AppCachePath(appName: "Spotify", relativePaths: [
                "Library/Caches/com.spotify.client",
            ]),
            AppCachePath(appName: "Slack", relativePaths: [
                "Library/Caches/com.tinyspeck.slackmacgap",
                "Library/Application Support/Slack/Cache",
            ]),
            AppCachePath(appName: "Discord", relativePaths: [
                "Library/Caches/com.hnc.Discord",
                "Library/Application Support/discord/Cache",
            ]),
            AppCachePath(appName: "Telegram", relativePaths: [
                "Library/Caches/ru.keepcoder.Telegram",
            ]),
            AppCachePath(appName: "Microsoft Teams", relativePaths: [
                "Library/Caches/com.microsoft.teams2",
                "Library/Application Support/Microsoft/Teams/Cache",
            ]),
            AppCachePath(appName: "Steam", relativePaths: [
                "Library/Application Support/Steam/appcache",
                "Library/Application Support/Steam/depotcache",
                "Library/Application Support/Steam/logs",
            ]),
            AppCachePath(appName: "Adobe", relativePaths: [
                "Library/Caches/Adobe",
                "Library/Application Support/Adobe/Common/Media Cache Files",
            ]),
            AppCachePath(appName: "JetBrains", relativePaths: [
                "Library/Caches/JetBrains",
                "Library/Logs/JetBrains",
            ]),
            AppCachePath(appName: "VS Code", relativePaths: [
                "Library/Caches/com.microsoft.VSCode",
                "Library/Application Support/Code/logs",
                "Library/Application Support/Code/CachedData",
                "Library/Application Support/Code/CachedExtensions",
            ]),
            AppCachePath(appName: "Obsidian", relativePaths: [
                "Library/Caches/md.obsidian",
                "Library/Application Support/obsidian/Cache",
            ]),
            AppCachePath(appName: "Zoom", relativePaths: [
                "Library/Caches/us.zoom.xos",
            ]),
            AppCachePath(appName: "WeChat", relativePaths: [
                "Library/Caches/com.tencent.xinWeChat",
            ]),
            AppCachePath(appName: "WhatsApp", relativePaths: [
                "Library/Caches/net.whatsapp.WhatsApp",
            ]),
            AppCachePath(appName: "Figma", relativePaths: [
                "Library/Caches/com.figma.Desktop",
            ]),
            AppCachePath(appName: "Sketch", relativePaths: [
                "Library/Caches/com.bohemiancoding.sketch3",
            ]),
            AppCachePath(appName: "Dropbox", relativePaths: [
                "Library/Dropbox/.dropbox.cache",
                "Dropbox/.dropbox.cache",
            ]),
            AppCachePath(appName: "Google Drive", relativePaths: [
                "Library/Application Support/Google/DriveFS",
            ]),
            AppCachePath(appName: "Claude", relativePaths: [
                "Library/Caches/com.anthropic.claudefordesktop",
                "Library/Logs/Claude",
            ]),
            AppCachePath(appName: "ChatGPT", relativePaths: [
                "Library/Caches/com.openai.chat",
            ]),
        ]
    }

    func scan(onFile: @escaping @Sendable (String) -> Void) async throws -> [CleanItem] {
        let fm = FileManager.default
        let home = fm.homeDirectoryForCurrentUser
        var items: [CleanItem] = []

        for app in appCaches {
            for relPath in app.relativePaths {
                let url = home.appendingPathComponent(relPath)
                var isDir: ObjCBool = false
                guard fm.fileExists(atPath: url.path(percentEncoded: false), isDirectory: &isDir) else { continue }

                onFile(url.path(percentEncoded: false))
                let size = FileSystemService.size(of: url)
                if size > 0 {
                    items.append(CleanItem(path: url, size: size, isDirectory: isDir.boolValue))
                }
            }
        }

        return items.sorted { $0.size > $1.size }
    }
}
