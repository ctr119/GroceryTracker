import Foundation
import CoreData

protocol GroceryDataSource {
    func createFood(_ foodList: [FoodDBO]) async throws
    func getFoodList(_ names: [String]?) async throws -> [FoodDBO]
    func createGrocery(dbo: GroceryDBO) async throws
    func getGroceries(byIds ids: [UUID]?, byNames names: [String]?) async throws -> [GroceryDBO]
    func getPrices(for foodId: UUID) async throws -> [PriceDBO]
    func registerPrices(_ prices: [PriceDBO]) async throws
}

class GroceryDataSourceImplementation: GroceryDataSource {
    private let container: PersistentContainer
    
    init(container: PersistentContainer) {
        self.container = container
    }
    
    func createFood(_ foodList: [FoodDBO]) async throws {
        try await container.saveContext(dbObjects: foodList)
    }
    
    func getFoodList(_ names: [String]? = nil) async throws -> [FoodDBO] {
        let request = FoodEntity.fetchRequest()
        if let names = names {
            request.predicate = NSPredicate(
                format: "name IN %@", names
            )
        }
        
        return try await container.fetch(request: request).compactMap { $0 }
    }
    
    func createGrocery(dbo: GroceryDBO) async throws {
        try await container.saveContext(dbObjects: [dbo])
    }
    
    func getGroceries(byIds ids: [UUID]? = nil, byNames names: [String]? = nil) async throws -> [GroceryDBO] {
        let request = GroceryEntity.fetchRequest()
        var predicates: [NSPredicate] = []
        
        if let ids = ids {
            predicates.append(NSPredicate(
                format: "gid IN %@", ids
            ))
        }
        
        if let names = names {
            predicates.append(NSPredicate(
                format: "name IN %@", names
            ))
        }
        
        if predicates.count > 0 {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
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
    
    func registerPrices(_ prices: [PriceDBO]) async throws {
        try await container.saveContext(dbObjects: prices)
    }
}
