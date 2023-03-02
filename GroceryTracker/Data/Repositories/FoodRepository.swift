import Foundation

protocol FoodRepository {
    func createFood(names: [String]) async throws -> [Food]
    func getFoodList() async throws -> [Food]
    func getFoodPrices(_ id: UUID) async throws -> [Grocery: Price] // TODO: Move method to PriceRepository
}

struct FoodRepositoryImplementation: FoodRepository {
    private let dataSource: GroceryDataSource
    
    init(dataSource: GroceryDataSource) {
        self.dataSource = dataSource
    }
    
    func createFood(names: [String]) async throws -> [Food] {
        guard !names.isEmpty else { return [] }
        
        let existingFood = try await dataSource.getFoodList(names)
        let existingFoodNames = existingFood.map { $0.name }
        
        let nonExistingFood = names
            .filter { !existingFoodNames.contains($0) }
            .map { FoodDBO(fid: UUID(), name: $0) }
        
        try await dataSource.createFood(nonExistingFood)
        
        return (existingFood + nonExistingFood).map {
            Food(id: $0.fid, name: $0.name)
        }
    }
    
    func getFoodList() async throws -> [Food] {
        try await dataSource.getFoodList(nil).map {
            Food(id: $0.fid, name: $0.name)
        }
    }
    
    func getFoodPrices(_ id: UUID) async throws -> [Grocery: Price] {
        let prices = try await dataSource.getPrices(for: id)
        
        let groceryIds = prices.map { $0.gid }
        let groceries = try await dataSource.getGroceries(groceryIds)
                
        return groceries.reduce(into: [:]) { partialResult, groceryDBO in
            guard let saleDbo = prices.first(where: { saleDBO in
                groceryDBO.gid == saleDBO.gid
            }) else { return }
            
            let grocery = Grocery(id: groceryDBO.gid, name: groceryDBO.name)
            let sale = Price(amount: saleDbo.amount, unit: saleDbo.unit)
            partialResult[grocery] = sale
        }
    }
}
