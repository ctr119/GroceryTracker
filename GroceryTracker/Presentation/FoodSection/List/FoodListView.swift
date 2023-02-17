import SwiftUI

struct FoodListView: View {
    @ObservedObject private var viewModel: FoodListViewModel
    
    init(viewModel: FoodListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.foodListModel) { foodModel in
            NavigationLink(destination: FoodDetailsView(food: foodModel)) {
                BasicFoodRow(model: foodModel)
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.onViewLoads()
        }
    }
}

extension FoodListView {
    enum DI {
        static func inject(searchText: Binding<String>) -> FoodListView {
            FoodListView(viewModel: FoodListViewModel(searchText: searchText,
                                                      getFoodListUseCase: GetFoodListUseCaseImplementation(foodRepository: FoodRepositoryImplementation(dataSource: GroceryDataSourceFactory.make()))))
        }
    }
}

struct FoodListView_Previews: PreviewProvider {
    @State static var seartchText: String = ""
    
    static var previews: some View {
        FoodListView(viewModel: FoodListViewModel(searchText: $seartchText,
                                                  getFoodListUseCase: GetFoodListUseCaseMock()))
    }
}

private struct GetFoodListUseCaseMock: GetFoodListUseCase {
    func callAsFunction() async throws -> [Food] {
        [
            Food(id: UUID(), name: "Tomato"),
            Food(id: UUID(), name: "Lettuce"),
            Food(id: UUID(), name: "Potato")
        ]
    }
}
