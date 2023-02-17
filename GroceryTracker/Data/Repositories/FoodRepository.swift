import Foundation

protocol FoodRepository {
    func getFoodList() async throws -> [Food]
    func getFoodSales(_ id: UUID) async throws -> [Grocery: Sale]
}

struct FoodRepositoryImplementation: FoodRepository {
    private let dataSource: GroceryDataSource
    
    init(dataSource: GroceryDataSource) {
        self.dataSource = dataSource
    }
    
    func getFoodList() async throws -> [Food] {
        try await dataSource.getFoodList().map {
            Food(id: $0.fid, name: $0.name)
        }
    }
    
    func getFoodSales(_ id: UUID) async throws -> [Grocery: Sale] {
        let sales = try await dataSource.getSales(for: id)
        
        let groceryIds = sales.map { $0.gid }
        let groceries = try await dataSource.getGroceries(groceryIds)
                
        return groceries.reduce(into: [:]) { partialResult, groceryDBO in
            guard let saleDbo = sales.first(where: { saleDBO in
                groceryDBO.gid == saleDBO.gid
            }) else { return }
            
            let grocery = Grocery(id: groceryDBO.gid, name: groceryDBO.name)
            let sale = Sale(price: saleDbo.price, unit: saleDbo.unit)
            partialResult[grocery] = sale
        }
    }
}
