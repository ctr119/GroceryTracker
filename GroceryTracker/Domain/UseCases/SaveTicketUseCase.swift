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
        
        do {
            let foodNames = foodDictionary.map { $0.key }
            let createdFood = try await foodRepository.createFood(names: foodNames)
            guard foodNames.count == createdFood.count else { return } // We could throw an error here
        } catch {
            
        }
        
        // TODO: Create a PURCHASE repository
            // It will manage stuff like, PRICES, PURCHASES and TICKETS
            // Ticket creation
            // Price assignment
        
        // TODO: Create a ticket record (return the ID)
        
        
        // TODO: Establish a PRICE relationship between the product and the grocery
        
        // TODO: Establish a PURCHASE relationship between the price and the ticket
    }
}
