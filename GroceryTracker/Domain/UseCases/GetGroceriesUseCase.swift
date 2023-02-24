import Foundation

protocol GetGroceriesUseCase {
    func callAsFunction() -> [Grocery]
}

struct GetGroceriesUseCaseImplementation: GetGroceriesUseCase {
    private let groceryRepository: GroceryRepository
    
    init(groceryRepository: GroceryRepository) {
        self.groceryRepository = groceryRepository
    }
    
    func callAsFunction() -> [Grocery] {[
        .init(id: UUID(), name: "Carrefour"),
        .init(id: UUID(), name: "Lidl"),
        .init(id: UUID(), name: "Mercadona")
    ]}
}
