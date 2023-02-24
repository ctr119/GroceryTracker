import Foundation

protocol GroceryRepository {
    func createGrocery(_ grocery: Grocery) async
    func getGroceries() async throws -> [Grocery]
}

struct GroceryRepositoryImplementation: GroceryRepository {
    private let dataSource: GroceryDataSource
    
    init(dataSource: GroceryDataSource) {
        self.dataSource = dataSource
    }
    
    func createGrocery(_ grocery: Grocery) async {
        do {
            let exists = try await dataSource.getGroceries([grocery.id]).count > 0
            if !exists {
                let groceryDbo = GroceryDBO(gid: grocery.id, name: grocery.name)
                try await dataSource.createGrocery(dbo: groceryDbo)
            }
        } catch {
            // Do not do anything
        }
    }
    
    func getGroceries() async throws -> [Grocery] {
        try await dataSource.getGroceries(nil).map {
            Grocery(id: $0.gid, name: $0.name)
        }
    }
}
