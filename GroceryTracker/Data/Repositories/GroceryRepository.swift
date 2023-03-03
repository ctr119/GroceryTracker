import Foundation

protocol GroceryRepository {
    func createGrocery(_ grocery: Grocery) async throws
    func getGroceries() async throws -> [Grocery]
}

struct GroceryRepositoryImplementation: GroceryRepository {
    private let dataSource: GroceryDataSource
    
    init(dataSource: GroceryDataSource) {
        self.dataSource = dataSource
    }
    
    func createGrocery(_ grocery: Grocery) async throws {
        do {
            let groceryDbo = GroceryDBO(gid: grocery.id, name: grocery.name)
            try await dataSource.createGrocery(dbo: groceryDbo)
            
        } catch {
            switch error {
            case DataError.alreadyExistingGrocery:
                throw DomainError.existingGrocery
            
            default:
                throw DomainError.groceryNotCreated
            }
        }
    }
    
    func getGroceries() async throws -> [Grocery] {
        try await dataSource.getGroceries(byIds: nil, byNames: nil).map {
            Grocery(id: $0.gid, name: $0.name)
        }
    }
}
