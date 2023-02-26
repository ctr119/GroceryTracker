import SwiftUI

class NewTicketViewModel: ObservableObject {
    @Published var rows: [TextPage.Row] = []
    var groceries: [NewTicketView.GroceryModel] = []
    let auxiliarGrocery = NewTicketView.GroceryModel(id: UUID(), name: "Add a new grocery")
    
    private var ticketModel: ScannedTicketModel
    private let getGroceriesUseCase: GetGroceriesUseCase
    private let saveTicketUseCase: SaveTicketUseCase
    private let cancelAction: () -> Void
    
    init(ticketModel: ScannedTicketModel,
         getGroceriesUseCase: GetGroceriesUseCase,
         saveTicketUseCase: SaveTicketUseCase,
         cancelAction: @escaping () -> Void) {
        self.ticketModel = ticketModel
        self.getGroceriesUseCase = getGroceriesUseCase
        self.saveTicketUseCase = saveTicketUseCase
        self.cancelAction = cancelAction
    }
    
    func onAppear() async {
        do {
            groceries = try await getGroceriesUseCase().map {
                .init(id: $0.id, name: $0.name)
            } + [auxiliarGrocery]
            
            await MainActor.run {
                rows = ticketModel.pages.flatMap { $0.rows }
            }
        } catch {
            // exceptions
        }
    }
    
    func saveTicket(for groceryModel: NewTicketView.GroceryModel?, or groceryName: String) async {
        let getGrocery: () -> Grocery? = {
            if let model = groceryModel, model != self.auxiliarGrocery {
                return Grocery(id: model.id, name: model.name)
            } else if !groceryName.isEmpty {
                return Grocery(id: UUID(), name: groceryName)
            }
            return nil
        }
        
        guard let grocery = getGrocery(), !rows.isEmpty else { return }
        
        let foodDictionary: [String: (Price, Int)] = rows.reduce(into: [:]) { partialResult, row in
            guard let priceAmount = Double(row.singlePrice),
                  let quantity = Int(row.units) else { return }
            
            partialResult[row.name] = (Price(amount: priceAmount, unit: "€"), quantity)
        }
        
        await saveTicketUseCase(grocery: grocery, foodDictionary: foodDictionary)
    }
    
    func cancelTicket() {
        cancelAction()
    }
    
    func remove(row: TextPage.Row) {
        guard let index = rows.firstIndex(where: { $0 == row }),
              index < rows.count else { return }
        rows.remove(at: index)
    }
}
