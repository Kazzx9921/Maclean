#if APPSTORE
import StoreKit
import SwiftUI

@MainActor
final class StoreService: ObservableObject {
    static let shared = StoreService()

    static let proProductID = "com.geekaz.maclean.pro"
    static let freeQuota: Int64 = 20 * 1024 * 1024 * 1024 // 20 GB

    @Published private(set) var isPro: Bool = false
    @Published var showPaywall: Bool = false
    @Published private(set) var product: Product?

    // MARK: - Lifetime Cleaned (independent of HistoryService)

    private static let lifetimeCleanedKey = "com.geekaz.maclean.lifetimeCleaned"

    var lifetimeCleaned: Int64 {
        Int64(UserDefaults.standard.integer(forKey: Self.lifetimeCleanedKey))
    }

    func addCleaned(_ bytes: Int64) {
        let current = lifetimeCleaned
        UserDefaults.standard.set(Int(current + bytes), forKey: Self.lifetimeCleanedKey)
    }

    // MARK: - Payment Check

    var requiresPayment: Bool {
        !isPro && lifetimeCleaned >= Self.freeQuota
    }

    // MARK: - Init

    private var transactionListener: Task<Void, Never>?

    private init() {
        transactionListener = listenForTransactions()
        Task {
            await loadProduct()
            await checkEntitlements()
        }
    }

    // MARK: - Load Product

    private func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.proProductID])
            product = products.first
        } catch {
            // Product loading failed — will retry on purchase
        }
    }

    // MARK: - Purchase

    func purchase() async throws -> Bool {
        let prod: Product
        if let cached = product {
            prod = cached
        } else {
            guard let fetched = try await Product.products(for: [Self.proProductID]).first else {
                return false
            }
            product = fetched
            prod = fetched
        }

        let result = try await prod.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            isPro = true
            return true
        case .userCancelled:
            return false
        case .pending:
            return false
        @unknown default:
            return false
        }
    }

    // MARK: - Restore

    func restore() async {
        try? await AppStore.sync()
        await checkEntitlements()
    }

    // MARK: - Transaction Listener

    private func listenForTransactions() -> Task<Void, Never> {
        Task { @MainActor [weak self] in
            for await result in Transaction.updates {
                if let self, let transaction = try? self.checkVerified(result) {
                    await transaction.finish()
                    self.isPro = true
                }
            }
        }
    }

    // MARK: - Entitlements

    private func checkEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result),
               transaction.productID == Self.proProductID {
                isPro = true
                return
            }
        }
    }

    private nonisolated func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified: throw StoreError.unverified
        case .verified(let value): return value
        }
    }

    enum StoreError: Error {
        case unverified
    }
}
#endif
