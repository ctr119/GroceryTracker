import Foundation

protocol GetGroceriesUseCase {
    func callAsFunction() async throws -> [Grocery]
}

struct GetGroceriesUseCaseImplementation: GetGroceriesUseCase {
    private let groceryRepository: GroceryRepository
    
    init(groceryRepository: GroceryRepository) {
        self.groceryRepository = groceryRepository
    }
    
    func callAsFunction() async throws -> [Grocery] {
        try await groceryRepository.getGroceries()
    }
}
