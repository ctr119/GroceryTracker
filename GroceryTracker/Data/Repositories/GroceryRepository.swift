import Foundation

protocol GroceryRepository {
    func getGroceries() async throws -> [Grocery]
}

struct GroceryRepositoryImplementation: GroceryRepository {
    private let dataSource: GroceryDataSource
    
    init(dataSource: GroceryDataSource) {
        self.dataSource = dataSource
    }
    
    func getGroceries() async throws -> [Grocery] {
        try await dataSource.getGroceries(nil).map {
            Grocery(id: $0.gid, name: $0.name)
        }
    }
}
