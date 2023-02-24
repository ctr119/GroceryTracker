import Foundation
import CoreData

protocol GroceryDataSource {
    func getFoodList() async throws -> [FoodDBO]
    func createGrocery(dbo: GroceryDBO) async throws
    func getGroceries(_ ids: [UUID]?) async throws -> [GroceryDBO]
    func getPrices(for foodId: UUID) async throws -> [PriceDBO]
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
    
    func getPrices(for foodId: UUID) async throws -> [PriceDBO] {
        let request = PriceEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "fid = %@", foodId as CVarArg
        )
        
        return try await container.fetch(request: request).compactMap { $0 }
    }
}
