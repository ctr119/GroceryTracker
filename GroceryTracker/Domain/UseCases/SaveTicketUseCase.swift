import Foundation

protocol SaveTicketUseCase {
    func callAsFunction(grocery: Grocery, items: [TextPage.Row]) async
}

struct SaveTicketUseCaseImplementation: SaveTicketUseCase {
    private let foodRepository: FoodRepository
    private let groceryRepository: GroceryRepository
    
    init(foodRepository: FoodRepository,
         groceryRepository: GroceryRepository) {
        self.foodRepository = foodRepository
        self.groceryRepository = groceryRepository
    }
    
    // TODO: Change [TextPage.Row] for [Food : (Price, Int)] being the Int the quantity
    func callAsFunction(grocery: Grocery, items: [TextPage.Row]) async {
        await groceryRepository.createGrocery(grocery)
    }
}
