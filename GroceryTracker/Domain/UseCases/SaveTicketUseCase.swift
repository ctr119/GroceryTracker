import Foundation

protocol SaveTicketUseCase {
    func callAsFunction(grocery: Grocery, foodDictionary: [String : (Price, Int)]) async
}

struct SaveTicketUseCaseImplementation: SaveTicketUseCase {
    private let foodRepository: FoodRepository
    private let groceryRepository: GroceryRepository
    
    init(foodRepository: FoodRepository,
         groceryRepository: GroceryRepository) {
        self.foodRepository = foodRepository
        self.groceryRepository = groceryRepository
    }
    
    func callAsFunction(grocery: Grocery, foodDictionary: [String : (Price, Int)]) async {
        await groceryRepository.createGrocery(grocery)
        
        // TODO: Create a ticket record (return the ID)
        
        // TODO: Get the Food ID if it exists, or create the food if needed (return the ID)
        
        // TODO: Establish a PRICE relationship between the product and the grocery
        
        // TODO: Establish a PURCHASE relationship between the price and the ticket
    }
}
