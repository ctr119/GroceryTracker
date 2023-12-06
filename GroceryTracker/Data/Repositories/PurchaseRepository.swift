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
                let food = $0.key
                let quantity = $0.value
                
                return PurchaseDBO(tid: ticketId, gid: grocery.id, fid: food.id, quantity: quantity)
            }
            try await dataSource.associatePurchases(purchases)
        } catch {
            throw DomainError.ticketNotCreated
        }
    }
}
