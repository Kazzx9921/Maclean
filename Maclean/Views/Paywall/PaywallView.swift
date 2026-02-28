#if APPSTORE
import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var storeService: StoreService
    @EnvironmentObject var l10n: L10n
    @Environment(\.dismiss) var dismiss

    @State private var isPurchasing = false
    @State private var isRestoring = false
    @State private var error: String?

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(.tint)

            Text(l10n.paywallHeadline(FileSize.formatted(storeService.lifetimeCleaned)))
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            Text(l10n.paywallSubtitle)
                .foregroundStyle(.secondary)
                .font(.callout)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 8) {
                benefitRow("checkmark.circle.fill", l10n.benefitUnlimited)
                benefitRow("checkmark.circle.fill", l10n.benefitLifetime)
                benefitRow("checkmark.circle.fill", l10n.benefitUpdates)
            }
            .padding()

            Button {
                Task { await purchase() }
            } label: {
                if isPurchasing {
                    ProgressView()
                        .controlSize(.small)
                        .frame(minWidth: 200)
                } else {
                    Text(purchaseButtonText)
                        .frame(minWidth: 200)
                }
            }
            .glassProminentButtonStyle()
            .controlSize(.large)
            .disabled(isPurchasing || isRestoring)

            HStack(spacing: 24) {
                Button {
                    Task { await restorePurchase() }
                } label: {
                    if isRestoring {
                        ProgressView()
                            .controlSize(.mini)
                    } else {
                        Text(l10n.restorePurchase)
                    }
                }
                .font(.callout)
                .disabled(isPurchasing || isRestoring)

                Button(l10n.maybeLater) { dismiss() }
                    .font(.callout)
            }
            .foregroundStyle(.secondary)

            if let error {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
        .padding(32)
        .frame(width: 400)
        .onChange(of: storeService.isPro) {
            if storeService.isPro { dismiss() }
        }
    }

    private var purchaseButtonText: String {
        if let product = storeService.product {
            return l10n.unlockPro + " — " + product.displayPrice
        }
        return l10n.unlockPro + " — $3.99"
    }

    private func purchase() async {
        isPurchasing = true
        error = nil
        do {
            _ = try await storeService.purchase()
        } catch {
            self.error = error.localizedDescription
        }
        isPurchasing = false
    }

    private func restorePurchase() async {
        isRestoring = true
        error = nil
        await storeService.restore()
        if !storeService.isPro {
            error = l10n.restoreNotFound
        }
        isRestoring = false
    }

    private func benefitRow(_ icon: String, _ text: String) -> some View {
        Label(text, systemImage: icon)
            .foregroundStyle(.primary)
    }
}
#endif
