import Foundation

protocol GetFoodListUseCase {
    func callAsFunction() async throws -> [Food]
}

struct GetFoodListUseCaseImplementation: GetFoodListUseCase {
    private let foodRepository: FoodRepository

    init(foodRepository: FoodRepository) {
        self.foodRepository = foodRepository
    }
    
    func callAsFunction() async throws -> [Food] {
        let food = try await foodRepository.getFoodList()
        
        if food.isEmpty {
            throw DomainError.noFoodFound
        }
        
        return food
    }
}
