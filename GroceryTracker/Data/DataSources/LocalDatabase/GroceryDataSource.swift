import Foundation
import CoreData

protocol GroceryDataSource {
    func createFood(_ names: [String]) async throws -> [FoodDBO]
    func getFoodList(_ names: [String]?) async throws -> [FoodDBO]
    func createGrocery(dbo: GroceryDBO) async throws
    func getGroceries(byIds ids: [UUID]?, byNames names: [String]?) async throws -> [GroceryDBO]
    func getPrices(for foodId: UUID) async throws -> [PriceDBO]
    func registerPrices(_ prices: [PriceDBO]) async throws
    func createTicket() async throws -> UUID
    func associatePurchases(_ purchases: [PurchaseDBO]) async throws
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
        
        try await container.saveInContext(dbObjects: nonExistingFood)
        
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
        
        try await container.saveInContext(dbObjects: [dbo])
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
        var foodIds: [UUID] = []
        var groceryIds: [UUID] = []
        prices.forEach {
            foodIds.append($0.fid)
            groceryIds.append($0.gid)
        }
        
        let existingPricesRequest = PriceEntity.fetchRequest()
        existingPricesRequest.predicate = NSPredicate(
            format: "fid IN %@ AND gid IN %@", foodIds, groceryIds
        )
        let existingPrices = try await container.fetch(request: existingPricesRequest).compactMap { $0 }
        
        try await container.runBlock({ context in
            // update existing prices
            for existingPrice in existingPrices where prices.contains(where: {
                $0.fid == existingPrice.fid
                && $0.gid == existingPrice.gid
                && $0.amount != existingPrice.amount }) {
                
                guard var priceToUpdate = existingPrice.toNSManagedObject(context: context) as? PriceEntity,
                      let newPrice = prices.first(where: { $0.fid == existingPrice.fid && $0.gid == existingPrice.gid }) else { continue }
                
                priceToUpdate.amount = newPrice.amount
            }
            
            // create new prices
            let newPrices = prices.filter { newPrice in
                !existingPrices.contains { existingPrice in
                    newPrice.fid == existingPrice.fid
                    && newPrice.gid == existingPrice.gid
                }
            }
            newPrices.forEach {
                _ = $0.toNSManagedObject(context: context)
            }
        })
    }
    
    func createTicket() async throws -> UUID {
        let ticket = TicketDBO(tid: UUID(), date: Date.now)
        
        try await container.saveInContext(dbObjects: [ticket])
        
        return ticket.tid
    }
    
    func associatePurchases(_ purchases: [PurchaseDBO]) async throws {
        try await container.saveInContext(dbObjects: purchases)
    }
}
