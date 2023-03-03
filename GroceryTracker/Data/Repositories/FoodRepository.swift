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
        guard !names.isEmpty else {
            throw DomainError.emptyFoodNameList
        }
        
        do {
            return try await dataSource.createFood(names).map {
                Food(id: $0.fid, name: $0.name)
            }
        } catch {
            throw DomainError.foodNotCreated
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
        let groceries = try await dataSource.getGroceries(byIds: groceryIds, byNames: nil)
                
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
