import SwiftUI

struct SystemToolsView: View {
    @EnvironmentObject var l10n: L10n

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                SystemToolCard(
                    title: l10n.flushDNS,
                    description: l10n.flushDNSDesc,
                    icon: "network",
                    requiresAdmin: true
                ) {
                    await SystemToolsService().flushDNS()
                }

                SystemToolCard(
                    title: l10n.dockerCleanup,
                    description: l10n.dockerCleanupDesc,
                    icon: "shippingbox",
                    requiresAdmin: false
                ) {
                    await SystemToolsService().dockerPrune()
                }

                SystemToolCard(
                    title: l10n.rebuildSpotlight,
                    description: l10n.rebuildSpotlightDesc,
                    icon: "magnifyingglass",
                    requiresAdmin: true
                ) {
                    await SystemToolsService().rebuildSpotlight()
                }

                SystemToolCard(
                    title: l10n.rebuildLaunchServices,
                    description: l10n.rebuildLaunchServicesDesc,
                    icon: "arrow.right.doc.on.clipboard",
                    requiresAdmin: false
                ) {
                    await SystemToolsService().rebuildLaunchServices()
                }

                SystemToolCard(
                    title: l10n.clearFontCache,
                    description: l10n.clearFontCacheDesc,
                    icon: "textformat",
                    requiresAdmin: true
                ) {
                    await SystemToolsService().clearFontCache()
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle(l10n.systemTools)
    }
}

// MARK: - Tool Card

private struct SystemToolCard: View {
    let title: String
    let description: String
    let icon: String
    let requiresAdmin: Bool
    let action: () async -> SystemToolsService.ToolResult

    @EnvironmentObject var l10n: L10n
    @State private var isRunning = false
    @State private var resultMessage: String?
    @State private var isSuccess = false

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.secondary)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body.bold())
                    .foregroundStyle(.primary)

                HStack(spacing: 4) {
                    Text(description)
                    if requiresAdmin {
                        Text("(\(l10n.requiresAdmin))")
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            if isRunning {
                ProgressView()
                    .controlSize(.small)
            } else if let message = resultMessage {
                HStack(spacing: 4) {
                    Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(isSuccess ? .green : .red)
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            } else {
                Button(l10n.runTool) {
                    run()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
            }
        }
        .padding(16)
        .glassBackground()
    }

    private func run() {
        isRunning = true
        resultMessage = nil
        Task {
            let result = await action()
            isRunning = false
            switch result {
            case .success(let msg):
                isSuccess = true
                resultMessage = msg.isEmpty ? l10n.completed : msg
            case .failure(let msg):
                isSuccess = false
                resultMessage = msg
            }
        }
    }
}
