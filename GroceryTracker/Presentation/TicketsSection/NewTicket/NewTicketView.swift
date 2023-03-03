import SwiftUI
import UIComponents

struct NewTicketView: View {
    struct GroceryModel: Identifiable, Hashable {
        let id: UUID
        let name: String
    }
    
    @State private var groceryName: String = ""
    @State private var selectedGrocery: GroceryModel?
    @ObservedObject private var viewModel: NewTicketViewModel
    
    init(viewModel: NewTicketViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            groceryPicker
            
            Divider()
            
            itemList
            
            Divider()
            
            SaveBottomBar {
                Task {
                    await viewModel.saveTicket(for: selectedGrocery, or: groceryName)
                }
            } cancelAction: {
                viewModel.cancelTicket()
            }
            .background(DesignSystem.ColorScheme.Surface.primary.color.opacity(0.5))
        }
        .background(DesignSystem.ColorScheme.Element.secondary.color)
        .task {
            await viewModel.onAppear()
        }
    }
    
    private var groceryPicker: some View {
        VStack {
            HStack {
                Picker("", selection: $selectedGrocery) {
                    ForEach(viewModel.groceries, id: \.id) { grocery in
                        Text(grocery.name)
                            .tag(grocery as GroceryModel?) // Needed for the selected one to get updated
                        /*
                         The type associated with the 'tag' of the entries in the Picker
                         must be identical to the type used for storing the selection.
                         https://stackoverflow.com/questions/59400474/swiftui-picker-with-selection-as-struct
                         */
                    }
                }
                .onAppear {
                    selectedGrocery = viewModel.auxiliarGrocery
                }
            }
            
            if selectedGrocery == viewModel.auxiliarGrocery {
                MaterialTextField(placeHolder: "Grocery's Name",
                                  value: $groceryName,
                                  textColor: .white,
                                  placeholderColor: .white,
                                  lineColor: .white,
                                  lineHeight: 1)
            }
        }
    }
    
    private var itemList: some View {
        ScrollView {
            VStack {
                ForEach($viewModel.rows, id: \.self) { row in
                    TicketRowView(row: row) {
                        viewModel.remove(row: row.wrappedValue)
                    }
                }
            }
            .padding()
        }
    }
}

extension NewTicketView {
    enum DI {
        static func inject(ticketModel: ScannedTicketModel, cancelAction: @escaping () -> Void) -> NewTicketView {
            let groceryDataSource = GroceryDataSourceFactory.make()
            let groceryRepository = GroceryRepositoryImplementation(dataSource: groceryDataSource)
            let foodRepository = FoodRepositoryImplementation(dataSource: groceryDataSource)
            let priceRepository = PriceRepositoryImplementation(dataSource: groceryDataSource)
            let purchaseRepository = PurchaseRepositoryImplementation(dataSource: groceryDataSource)
            
            let getGroceriesUseCase = GetGroceriesUseCaseImplementation(groceryRepository: groceryRepository)
            let saveTicketUseCase = SaveTicketUseCaseImplementation(foodRepository: foodRepository,
                                                                    groceryRepository: groceryRepository,
                                                                    priceRepository: priceRepository,
                                                                    purchaseRepository: purchaseRepository)
            
            let viewModel = NewTicketViewModel(ticketModel: ticketModel,
                                               getGroceriesUseCase: getGroceriesUseCase,
                                               saveTicketUseCase: saveTicketUseCase,
                                               cancelAction: cancelAction)
            return NewTicketView(viewModel: viewModel)
        }
    }
}

struct NewTicketView_Previews: PreviewProvider {
    @State static var model: ScannedTicketModel? = ScannedTicketModel(id: UUID(),
                                                                           pages: [getPage()])
    static func getPage() -> TextPage {
        let page = TextPage()
        page.addRow(["Lemon", "1.00", "1.5", "1.5"], distribution: .defaultDistribution)
        page.addRow(["Orange", "2.00", "3.5", "7.0"], distribution: .defaultDistribution)
        return page
    }
    
    static var previews: some View {
        NewTicketView(viewModel: NewTicketViewModel(ticketModel: model!,
                                                    getGroceriesUseCase: GetGroceriesUseCaseMock(),
                                                    saveTicketUseCase: SaveTicketUseCaseMock(),
                                                    cancelAction: {}))
    }
}

private struct GetGroceriesUseCaseMock: GetGroceriesUseCase {
    func callAsFunction() -> [Grocery] {[
        .init(id: UUID(), name: "Carrefour"),
        .init(id: UUID(), name: "Lidl"),
        .init(id: UUID(), name: "Mercadona")
    ]}
}

private struct SaveTicketUseCaseMock: SaveTicketUseCase {
    func callAsFunction(grocery: Grocery, foodDictionary: [String : (Price, Int)]) async {
        // empty
    }
}
