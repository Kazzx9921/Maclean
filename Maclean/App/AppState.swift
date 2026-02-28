import Foundation
import SwiftUI

enum WorkflowPhase: Equatable {
    case idle
    case scanning
    case scanned
    case dryRun
    case confirming
    case executing
    case pendingConfirm  // files moved to trash, waiting for user to test & confirm
    case completed
}

enum SidebarItem: String, CaseIterable, Identifiable {
    case dashboard
    case scan
    case appManager
    case projectCleanup
    case diskAnalyzer
    case appLipo
    case systemTools
    case whitelist
    case settings

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .dashboard: "square.grid.2x2"
        case .scan: "magnifyingglass"
        case .appManager: "app.badge.checkmark"
        case .projectCleanup: "hammer"
        case .diskAnalyzer: "chart.pie"
        case .appLipo: "scissors"
        case .systemTools: "wrench.and.screwdriver"
        case .whitelist: "list.bullet.rectangle"
        case .settings: "gearshape"
        }
    }
}

@MainActor
final class AppState: ObservableObject {
    static let shared = AppState()

    @Published var selectedSidebar: SidebarItem = .dashboard
    @Published var phase: WorkflowPhase = .idle
    @Published var scanResults: [CategoryResult] = []
    @Published var dryRunReport: DryRunReport?
    @Published var cleanSummary: CleanSummary?
    @Published var progress: Double = 0
    @Published var currentFile: String = ""
    @Published var scanFileLog: [String] = []

    private init() {}

    private static let maxFileLogEntries = 200

    func appendScanFile(_ path: String) {
        currentFile = path
        let home = FileManager.default.homeDirectoryForCurrentUser.path(percentEncoded: false)
        if scanFileLog.count >= Self.maxFileLogEntries {
            scanFileLog.removeFirst()
        }
        scanFileLog.append(path.replacingOccurrences(of: home, with: "~/"))
    }

    func reset() {
        phase = .idle
        scanResults = []
        dryRunReport = nil
        cleanSummary = nil
        progress = 0
        currentFile = ""
        scanFileLog = []
    }
}
