import Foundation

protocol CleanModule: Sendable {
    var name: String { get }
    var icon: String { get }
    func scan(onFile: @escaping @Sendable (String) -> Void) async throws -> [CleanItem]
}
