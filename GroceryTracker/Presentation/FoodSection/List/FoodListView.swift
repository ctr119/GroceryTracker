import SwiftUI

struct FoodListView: View {
    @ObservedObject private var viewModel: FoodListViewModel
    
    init(viewModel: FoodListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if viewModel.shouldShowEmptyScreen {
            VStack {
                EmptyErrorView(message: "It looks like you do not have any food to show.\n\nScan a grocery ticket or introduce that information manually so the products appear here.")
            }
            
        } else {
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
        Group {
            FoodListView(viewModel: FoodListViewModel(searchText: $seartchText,
                                                      getFoodListUseCase: GetFoodListUseCaseMock()))
            
            FoodListView(viewModel: FoodListViewModel(searchText: $seartchText,
                                                      getFoodListUseCase: CouldNotGetFoodListUseCaseMock()))
            .previewDisplayName("No food found")
        }
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

private struct CouldNotGetFoodListUseCaseMock: GetFoodListUseCase {
    func callAsFunction() async throws -> [Food] {
        throw DomainError.noFoodFound
    }
}
