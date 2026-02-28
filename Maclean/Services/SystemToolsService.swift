import Foundation

actor SystemToolsService {
    enum ToolResult: Sendable {
        case success(String)
        case failure(String)
    }

    func flushDNS() async -> ToolResult {
        let script = """
        do shell script "dscacheutil -flushcache && killall -HUP mDNSResponder" with administrator privileges
        """
        return await runAppleScript(script)
    }

    func dockerPrune() async -> ToolResult {
        let dockerPaths = ["/usr/local/bin/docker", "/opt/homebrew/bin/docker"]
        guard dockerPaths.contains(where: { FileManager.default.fileExists(atPath: $0) }) else {
            return .failure("Docker not installed")
        }

        return await runShell("/bin/zsh", arguments: ["-c", "docker system prune -af 2>&1"])
    }

    func rebuildSpotlight() async -> ToolResult {
        let script = """
        do shell script "mdutil -E /" with administrator privileges
        """
        return await runAppleScript(script)
    }

    func rebuildLaunchServices() async -> ToolResult {
        let lsregister = "/System/Library/Frameworks/CoreServices.framework/Versions/Current/Frameworks/LaunchServices.framework/Versions/Current/Support/lsregister"
        return await runShell(lsregister, arguments: ["-kill", "-r", "-domain", "local", "-domain", "system", "-domain", "user"])
    }

    func clearFontCache() async -> ToolResult {
        let script = """
        do shell script "atsutil databases -remove" with administrator privileges
        """
        return await runAppleScript(script)
    }

    // MARK: - Helpers

    private func runAppleScript(_ source: String) async -> ToolResult {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                var error: NSDictionary?
                let script = NSAppleScript(source: source)
                let result = script?.executeAndReturnError(&error)
                if let error {
                    let msg = error[NSAppleScript.errorMessage] as? String ?? "Unknown error"
                    continuation.resume(returning: .failure(msg))
                } else {
                    continuation.resume(returning: .success(result?.stringValue ?? "OK"))
                }
            }
        }
    }

    private func runShell(_ command: String, arguments: [String]) async -> ToolResult {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let process = Process()
                process.executableURL = URL(fileURLWithPath: command)
                process.arguments = arguments
                let pipe = Pipe()
                process.standardOutput = pipe
                process.standardError = pipe

                do {
                    let semaphore = DispatchSemaphore(value: 0)
                    process.terminationHandler = { _ in semaphore.signal() }
                    try process.run()
                    let timedOut = semaphore.wait(timeout: .now() + 120) == .timedOut
                    if timedOut {
                        process.terminate()
                        continuation.resume(returning: .failure("Process timed out"))
                        return
                    }
                    let data = pipe.fileHandleForReading.readDataToEndOfFile()
                    let output = String(data: data, encoding: .utf8) ?? ""
                    if process.terminationStatus == 0 {
                        continuation.resume(returning: .success(output))
                    } else {
                        continuation.resume(returning: .failure(output))
                    }
                } catch {
                    continuation.resume(returning: .failure(error.localizedDescription))
                }
            }
        }
    }
}
