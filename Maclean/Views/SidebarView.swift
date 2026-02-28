import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var l10n: L10n
    #if APPSTORE
    @EnvironmentObject var storeService: StoreService
    #endif

    private var mainItems: [SidebarItem] {
        [.dashboard, .scan, .appManager, .projectCleanup, .diskAnalyzer, .appLipo, .systemTools, .whitelist]
    }

    var body: some View {
        VStack(spacing: 0) {
            List(mainItems, selection: $appState.selectedSidebar) { item in
                Label(sidebarLabel(item), systemImage: item.icon)
                    .font(.body)
                    .tag(item)
            }
            .listStyle(.sidebar)

            HStack {
                #if APPSTORE
                if storeService.isPro {
                    Text("Pro")
                        .font(.caption.bold())
                        .foregroundStyle(.orange)
                        .padding(.leading, 12)
                }
                #endif

                Spacer()

                Button {
                    appState.selectedSidebar = .settings
                } label: {
                    Image(systemName: "gearshape")
                        .font(.title3)
                        .foregroundStyle(appState.selectedSidebar == .settings ? .primary : .secondary)
                }
                .buttonStyle(.plain)
                .padding(12)
            }
        }
        .navigationSplitViewColumnWidth(min: 180, ideal: 220, max: 280)
    }

    private func sidebarLabel(_ item: SidebarItem) -> String {
        switch item {
        case .dashboard: l10n.dashboard
        case .scan: l10n.scan
        case .appManager: l10n.appManager
        case .projectCleanup: l10n.projectCleanup
        case .diskAnalyzer: l10n.diskAnalyzer
        case .appLipo: l10n.appLipo
        case .systemTools: l10n.systemTools
        case .whitelist: l10n.whitelist
        case .settings: l10n.settings
        }
    }
}
