import Foundation
import CoreData

protocol GroceryDataSource {
    func getFoodList() async throws -> [FoodDBO]
    func createGrocery(dbo: GroceryDBO) async throws
    func getGroceries(_ ids: [UUID]?) async throws -> [GroceryDBO]
    func getSales(for productId: UUID) async throws -> [SaleDBO]
}

class GroceryDataSourceImplementation: GroceryDataSource {
    private let container: PersistentContainer
    
    init(container: PersistentContainer) {
        self.container = container
    }
    
    func getFoodList() async throws -> [FoodDBO] {
        let request = FoodEntity.fetchRequest()
        
        return try await container.fetch(request: request).compactMap { $0 }
    }
    
    func createGrocery(dbo: GroceryDBO) async throws {
        try await container.saveContext(dbObject: dbo)
    }
    
    func getGroceries(_ ids: [UUID]? = nil) async throws -> [GroceryDBO] {
        let request = GroceryEntity.fetchRequest()
        if let ids = ids {
            request.predicate = NSPredicate(
                format: "gid IN %@", ids
            )
        }
        
        return try await container.fetch(request: request).compactMap { $0 }
    }
    
    func getSales(for productId: UUID) async throws -> [SaleDBO] {
        let request = SaleEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "fid = %@", productId as CVarArg
        )
        
        return try await container.fetch(request: request).compactMap { $0 }
    }
}
