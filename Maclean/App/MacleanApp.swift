import SwiftUI

@main
struct MacleanApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState.shared
    @StateObject private var l10n = L10n.shared
    @StateObject private var appManagerVM = AppManagerViewModel.shared
    @StateObject private var projectCleanupVM = ProjectCleanupViewModel.shared
    @StateObject private var diskAnalyzerVM = DiskAnalyzerViewModel.shared
    @StateObject private var appLipoVM = AppLipoViewModel.shared
    @StateObject private var historyService = HistoryService.shared
    @StateObject private var whitelistService = WhitelistService.shared
    @StateObject private var sentinel = SentinelService.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
                .environmentObject(l10n)
                .environmentObject(appManagerVM)
                .environmentObject(projectCleanupVM)
                .environmentObject(diskAnalyzerVM)
                .environmentObject(appLipoVM)
                .environmentObject(historyService)
                .environmentObject(whitelistService)
                .environmentObject(sentinel)
                .frame(minWidth: 720, minHeight: 480)
        }
        .windowStyle(.automatic)
        .defaultSize(width: 900, height: 600)

        Settings {
            SettingsView()
                .environmentObject(appState)
                .environmentObject(l10n)
                .environmentObject(sentinel)
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
