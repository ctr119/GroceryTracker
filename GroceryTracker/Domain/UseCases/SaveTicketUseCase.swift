import Foundation

protocol SaveTicketUseCase {
    func callAsFunction(grocery: Grocery, foodDictionary: [String : (Price, Int)]) async
}

struct SaveTicketUseCaseImplementation: SaveTicketUseCase {
    private let foodRepository: FoodRepository
    private let groceryRepository: GroceryRepository
    private let priceRepository: PriceRepository
    
    init(foodRepository: FoodRepository,
         groceryRepository: GroceryRepository,
         priceRepository: PriceRepository) {
        self.foodRepository = foodRepository
        self.groceryRepository = groceryRepository
        self.priceRepository = priceRepository
    }
    
    func callAsFunction(grocery: Grocery, foodDictionary: [String : (Price, Int)]) async {
        
        // TODO: Final Check: creating objects with the same information as in the DB (instead of fetching them first), updates them properly in the DB
        
        do {
            try await groceryRepository.createGrocery(grocery)
        } catch {
            switch error {
            case DomainError.groceryNotCreated:
                return
            default:
                break
            }
        }
        
        do {
            let foodNames = foodDictionary.map { $0.key }
            let food = try await foodRepository.createFood(names: foodNames) // <--- TODO: Final Check
            guard foodNames.count == food.count else { return } // We could throw an error here
            
            let foodPrices: [Food: Price] = food.reduce(into: [:]) { partialResult, foodItem in
                if let dictValue = foodDictionary[foodItem.name] {
                    let price = dictValue.0
                    partialResult[foodItem] = price
                }
            }
            
            try await priceRepository.registerPrices(in: grocery, foodPrices: foodPrices) // <--- TODO: Final Check
        } catch {
            switch error {
            case DomainError.emptyFoodNameList:
                return
                
            case DomainError.foodNotCreated:
                return
                
            default: break
            }
        }
        
        // TODO: Create a PURCHASE repository
            // It will manage stuff like PURCHASES and TICKETS
            // Ticket creation
            // Price assignment
        
        // TODO: Create a ticket record (return the ID)
        
        // TODO: Establish a PURCHASE relationship between the price and the ticket
    }
}
