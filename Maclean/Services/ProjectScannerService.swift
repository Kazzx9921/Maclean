import Foundation

actor ProjectScannerService {
    private let artifactNames: [String: String] = [
        "node_modules": "Node.js",
        ".next": "Next.js",
        "dist": "Build Output",
        "build": "Build Output",
        "target": "Rust/Maven",
        ".gradle": "Gradle",
        "__pycache__": "Python",
        ".pytest_cache": "Python Test",
        ".tox": "Python Tox",
        "Pods": "CocoaPods",
        ".build": "Swift SPM",
        "venv": "Python Venv",
        ".venv": "Python Venv",
        ".dart_tool": "Flutter/Dart",
        "vendor": "Vendor",
    ]

    // Artifacts that can appear inside Xcode projects — skip "build" if .xcodeproj is present
    private let xcodeAmbiguous: Set<String> = ["build"]

    func scan(
        roots: [URL],
        onProgress: @MainActor @Sendable (String) -> Void
    ) async -> [ProjectInfo] {
        var results: [ProjectInfo] = []

        for root in roots {
            let found = collectArtifacts(root: root)
            for entry in found {
                await onProgress(entry.artifactURL.path(percentEncoded: false))
                let size = FileSystemService.directorySize(entry.artifactURL)
                guard size > 0 else { continue }

                results.append(ProjectInfo(
                    name: entry.parentName,
                    path: entry.parentURL,
                    artifactPath: entry.artifactURL,
                    artifactType: entry.artifactType,
                    size: size,
                    lastModified: entry.modDate
                ))
            }
        }

        return results.sorted { $0.size > $1.size }
    }

    private struct ArtifactEntry: Sendable {
        let artifactURL: URL
        let parentURL: URL
        let parentName: String
        let artifactType: String
        let modDate: Date?
    }

    private func collectArtifacts(root: URL) -> [ArtifactEntry] {
        let fm = FileManager.default
        guard let enumerator = fm.enumerator(
            at: root,
            includingPropertiesForKeys: [.isDirectoryKey, .contentModificationDateKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) else { return [] }

        var entries: [ArtifactEntry] = []

        while let obj = enumerator.nextObject() {
            guard let url = obj as? URL else { continue }
            let values = try? url.resourceValues(forKeys: [.isDirectoryKey])
            guard values?.isDirectory == true else { continue }

            let dirName = url.lastPathComponent

            if dirName == ".git" {
                enumerator.skipDescendants()
                continue
            }

            guard let artifactType = artifactNames[dirName] else { continue }

            // Skip "build" inside Xcode projects
            if xcodeAmbiguous.contains(dirName) {
                let parent = url.deletingLastPathComponent()
                let siblings = (try? fm.contentsOfDirectory(atPath: parent.path(percentEncoded: false))) ?? []
                if siblings.contains(where: { $0.hasSuffix(".xcodeproj") || $0.hasSuffix(".xcworkspace") }) {
                    continue
                }
            }

            enumerator.skipDescendants()

            let parentURL = url.deletingLastPathComponent()
            let parentName = parentURL.lastPathComponent
            let modDate = try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate

            entries.append(ArtifactEntry(
                artifactURL: url,
                parentURL: parentURL,
                parentName: parentName,
                artifactType: artifactType,
                modDate: modDate
            ))
        }

        return entries
    }
}
