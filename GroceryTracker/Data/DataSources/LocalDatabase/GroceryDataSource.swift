import Foundation
import CoreData

protocol GroceryDataSource {
    func createFood(_ names: [String]) async throws -> [FoodDBO]
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
    
    func createFood(_ names: [String]) async throws -> [FoodDBO] {
        let existingFood = try await getFoodList(names)
        let existingFoodNames = existingFood.map { $0.name }
        
        let nonExistingFood = names
            .filter { !existingFoodNames.contains($0) }
            .map { FoodDBO(fid: UUID(), name: $0) }
        
        try await container.saveContext(dbObjects: nonExistingFood)
        
        return existingFood + nonExistingFood
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
        if try await getGroceries(byIds: nil, byNames: [dbo.name]).count > 0 {
            throw DataError.alreadyExistingGrocery
        }
        
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
