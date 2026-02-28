import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            switch appState.selectedSidebar {
            case .dashboard:
                NavigationStack {
                    DashboardView()
                }
            case .scan:
                ScanView()
            case .appManager:
                AppManagerView()
            case .projectCleanup:
                ProjectCleanupView()
            case .diskAnalyzer:
                DiskAnalyzerView()
            case .appLipo:
                AppLipoView()
            case .systemTools:
                SystemToolsView()
            case .whitelist:
                WhitelistView()
            case .settings:
                SettingsView()
            }
        }
    }
}
