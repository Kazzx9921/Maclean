import Foundation

struct DevToolsCacheModule: CleanModule {
    let name = "Dev Tools Cache"
    let icon = "wrench.and.screwdriver"

    private struct DevToolPath {
        let label: String
        let relativePath: String
    }

    private var devToolPaths: [DevToolPath] {
        [
            DevToolPath(label: "npm", relativePath: ".npm/_cacache"),
            DevToolPath(label: "Yarn", relativePath: "Library/Caches/Yarn"),
            DevToolPath(label: "pnpm", relativePath: "Library/pnpm/store"),
            DevToolPath(label: "bun", relativePath: ".bun/install/cache"),
            DevToolPath(label: "pip", relativePath: "Library/Caches/pip"),
            DevToolPath(label: "Poetry", relativePath: "Library/Caches/pypoetry"),
            DevToolPath(label: "Go Modules", relativePath: "go/pkg/mod/cache"),
            DevToolPath(label: "Cargo", relativePath: ".cargo/registry/cache"),
            DevToolPath(label: "Gradle", relativePath: ".gradle/caches"),
            DevToolPath(label: "CocoaPods", relativePath: "Library/Caches/CocoaPods"),
            DevToolPath(label: "Composer", relativePath: "Library/Caches/composer"),
            DevToolPath(label: "Maven", relativePath: ".m2/repository"),
            DevToolPath(label: "NuGet", relativePath: ".nuget/packages"),
        ]
    }

    func scan(onFile: @escaping @Sendable (String) -> Void) async throws -> [CleanItem] {
        let fm = FileManager.default
        let home = fm.homeDirectoryForCurrentUser
        var items: [CleanItem] = []

        for tool in devToolPaths {
            let url = home.appendingPathComponent(tool.relativePath)
            guard fm.fileExists(atPath: url.path(percentEncoded: false)) else { continue }

            onFile(url.path(percentEncoded: false))
            let size = FileSystemService.directorySize(url)
            if size > 0 {
                items.append(CleanItem(path: url, size: size, isDirectory: true))
            }
        }

        return items.sorted { $0.size > $1.size }
    }
}
