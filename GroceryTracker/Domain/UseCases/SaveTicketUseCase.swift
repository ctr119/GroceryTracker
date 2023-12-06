import Foundation

protocol SaveTicketUseCase {
    func callAsFunction(grocery: Grocery, foodDictionary: [String : (Price, Int)]) async
}

struct SaveTicketUseCaseImplementation: SaveTicketUseCase {
    private let foodRepository: FoodRepository
    private let groceryRepository: GroceryRepository
    private let priceRepository: PriceRepository
    private let purchaseRepository: PurchaseRepository
    
    init(foodRepository: FoodRepository,
         groceryRepository: GroceryRepository,
         priceRepository: PriceRepository,
         purchaseRepository: PurchaseRepository) {
        self.foodRepository = foodRepository
        self.groceryRepository = groceryRepository
        self.priceRepository = priceRepository
        self.purchaseRepository = purchaseRepository
    }
    
    func callAsFunction(grocery: Grocery, foodDictionary: [String : (Price, Int)]) async {
        
        // TODO: Final Check: creating objects with the same information as in the DB (instead of fetching them first), updates them properly in the DB
        // ANSWER: No, CoreData uses the references. When creating multiple objects with the same info, that does not update the DB because the object's reference is different. So, we always have to retrieve the information first, update, and then save it.
        
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
            let food = try await foodRepository.createFood(names: foodNames)
            guard foodNames.count == food.count else { return } // We could throw an error here
            
            var foodPrices: [Food: Price] = [:]
            var foodQuantities: [Food: Int] = [:]
            
            food.forEach { foodItem in
                if let dictValue = foodDictionary[foodItem.name] {
                    let price = dictValue.0
                    let quantity = dictValue.1
                    foodPrices[foodItem] = price
                    foodQuantities[foodItem] = quantity
                }
            }
            
            try await priceRepository.registerPrices(in: grocery, foodPrices: foodPrices)
            try await purchaseRepository.createTicket(of: grocery, items: foodQuantities)
            
        } catch {
            switch error {
            case DomainError.emptyFoodNameList:
                return
                
            case DomainError.foodNotCreated:
                return
                
            case DomainError.ticketNotCreated:
                return
                
            default: break
            }
        }
    }
}
