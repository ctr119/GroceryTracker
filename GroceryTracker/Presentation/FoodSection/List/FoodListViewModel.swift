import Foundation
import SwiftUI

class FoodListViewModel: ObservableObject {
    @Published var foodListModel: [FoodModel] = []
    @Binding private var searchText: String
    
    private let getFoodListUseCase: GetFoodListUseCase
    
    init(searchText: Binding<String>, getFoodListUseCase: GetFoodListUseCase) {
        _searchText = searchText
        self.getFoodListUseCase = getFoodListUseCase
    }
    
    @MainActor
    func onViewLoads() async {
        do {
            let foodList = try await getFoodListUseCase()
                .map { FoodModel(id: $0.id, name: $0.name) }
            
            if !searchText.isEmpty {
                foodListModel = foodList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                return
            }
            
            foodListModel = foodList
        } catch {
            print("MUAC MUAC MUAC")
        }
    }
}
