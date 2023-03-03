import Foundation

protocol PurchaseRepository {
    func createTicket(of grocery: Grocery, items foodQuantities: [Food: Int]) async throws
}

struct PurchaseRepositoryImplementation: PurchaseRepository {
    private let dataSource: GroceryDataSource
    
    init(dataSource: GroceryDataSource) {
        self.dataSource = dataSource
    }
    
    func createTicket(of grocery: Grocery, items foodQuantities: [Food: Int]) async throws {
        do {
            let ticketId = try await dataSource.createTicket()
            
            let purchases = foodQuantities.map {
                PurchaseDBO(tid: ticketId, gid: grocery.id, fid: $0.key.id, quantity: $0.value)
            }
            try await dataSource.storePurchases(purchases)
        } catch {
            throw DomainError.ticketNotCreated
        }
    }
}
