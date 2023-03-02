import Foundation

protocol PriceRepository {
    func registerPrices(in grocery: Grocery, foodPrices: [Food : Price]) async throws
}

struct PriceRepositoryImplementation: PriceRepository {
    private let dataSource: GroceryDataSource
    
    init(dataSource: GroceryDataSource) {
        self.dataSource = dataSource
    }
    
    func registerPrices(in grocery: Grocery, foodPrices: [Food : Price]) async throws {
        let priceRecords = foodPrices.map {
            let food = $0.key
            let price = $0.value
            
            return PriceDBO(fid: food.id, gid: grocery.id, amount: price.amount, unit: price.unit)
        }
        try await dataSource.registerPrices(priceRecords)
    }
}
