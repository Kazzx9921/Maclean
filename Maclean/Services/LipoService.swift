import Foundation

struct UniversalAppInfo: Identifiable, Sendable {
    let id = UUID()
    let name: String
    let path: URL
    let currentArchSize: Int64
    let removableArchSize: Int64
    var isSelected: Bool = false
}

actor LipoService {
    func scanUniversalApps(
        onProgress: @MainActor @Sendable (String) -> Void
    ) async -> [UniversalAppInfo] {
        let fm = FileManager.default
        let appsDir = URL(fileURLWithPath: "/Applications")
        var results: [UniversalAppInfo] = []

        guard let contents = try? fm.contentsOfDirectory(
            at: appsDir,
            includingPropertiesForKeys: nil
        ) else { return [] }

        let currentArch: String = {
            #if arch(arm64)
            return "arm64"
            #else
            return "x86_64"
            #endif
        }()

        let removeArch: String = {
            #if arch(arm64)
            return "x86_64"
            #else
            return "arm64"
            #endif
        }()

        for appURL in contents {
            guard appURL.pathExtension == "app" else { continue }

            let appName = appURL.deletingPathExtension().lastPathComponent
            await onProgress(appName)

            // Skip system apps
            if let bundle = Bundle(url: appURL),
               let bundleID = bundle.bundleIdentifier,
               bundleID.hasPrefix("com.apple.") { continue }

            let macOSDir = appURL.appendingPathComponent("Contents/MacOS")
            guard let executables = try? fm.contentsOfDirectory(
                at: macOSDir,
                includingPropertiesForKeys: nil
            ) else { continue }

            var totalRemovable: Int64 = 0
            var totalCurrent: Int64 = 0
            var isUniversal = false

            for execURL in executables {
                guard let archInfo = getArchitectures(for: execURL) else { continue }
                if archInfo.contains(currentArch) && archInfo.contains(removeArch) {
                    isUniversal = true
                    let fileSize = FileSystemService.fileSize(execURL)
                    // Rough estimate: each arch is ~half the binary
                    totalRemovable += fileSize / 2
                    totalCurrent += fileSize / 2
                }
            }

            guard isUniversal && totalRemovable > 0 else { continue }

            results.append(UniversalAppInfo(
                name: appName,
                path: appURL,
                currentArchSize: totalCurrent,
                removableArchSize: totalRemovable
            ))
        }

        return results.sorted { $0.removableArchSize > $1.removableArchSize }
    }

    func thinApp(_ app: UniversalAppInfo) async -> Bool {
        let removeArch: String = {
            #if arch(arm64)
            return "x86_64"
            #else
            return "arm64"
            #endif
        }()

        let macOSDir = app.path.appendingPathComponent("Contents/MacOS")
        let fm = FileManager.default
        guard let executables = try? fm.contentsOfDirectory(at: macOSDir, includingPropertiesForKeys: nil) else {
            return false
        }

        for execURL in executables {
            guard let archs = getArchitectures(for: execURL),
                  archs.count > 1,
                  archs.contains(removeArch) else { continue }

            let outputPath = execURL.path(percentEncoded: false)
            let tempPath = outputPath + ".lipo_tmp"
            let backupPath = outputPath + ".lipo_backup"

            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/lipo")
            process.arguments = [outputPath, "-remove", removeArch, "-output", tempPath]

            do {
                guard runProcess(process), process.terminationStatus == 0 else {
                    try? fm.removeItem(atPath: tempPath)
                    continue
                }
                // Backup original before replacing
                try fm.copyItem(atPath: outputPath, toPath: backupPath)
                try fm.removeItem(atPath: outputPath)
                try fm.moveItem(atPath: tempPath, toPath: outputPath)

                // Re-sign the binary (ad-hoc)
                let codesign = Process()
                codesign.executableURL = URL(fileURLWithPath: "/usr/bin/codesign")
                codesign.arguments = ["--force", "--sign", "-", outputPath]
                _ = runProcess(codesign, timeout: 30)

                // Remove backup on success
                try? fm.removeItem(atPath: backupPath)
            } catch {
                // Restore from backup if available
                if fm.fileExists(atPath: backupPath) {
                    try? fm.removeItem(atPath: outputPath)
                    try? fm.moveItem(atPath: backupPath, toPath: outputPath)
                }
                try? fm.removeItem(atPath: tempPath)
            }
        }

        return true
    }

    private static let processTimeout: TimeInterval = 60

    private func runProcess(_ process: Process, timeout: TimeInterval = LipoService.processTimeout) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        process.terminationHandler = { _ in semaphore.signal() }
        do {
            try process.run()
        } catch {
            return false
        }
        if semaphore.wait(timeout: .now() + timeout) == .timedOut {
            process.terminate()
            return false
        }
        return true
    }

    private func getArchitectures(for url: URL) -> [String]? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/lipo")
        process.arguments = ["-archs", url.path(percentEncoded: false)]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = Pipe()

        guard runProcess(process), process.terminationStatus == 0 else { return nil }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let archs = output.components(separatedBy: " ").filter { !$0.isEmpty }
        return archs.count >= 2 ? archs : nil
    }
}
