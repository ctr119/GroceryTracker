import SwiftUI

class NewTicketViewModel: ObservableObject {
    @Published var rows: [TextPage.Row] = []
    var groceries: [NewTicketView.GroceryModel] = []
    let auxiliarGrocery = NewTicketView.GroceryModel(id: UUID(), name: "Add a new grocery")
    
    private let getGroceriesUseCase: GetGroceriesUseCase
    private var ticketModel: ScannedTicketModel
    private let cancelAction: () -> Void
    
    init(getGroceriesUseCase: GetGroceriesUseCase,
         ticketModel: ScannedTicketModel,
         cancelAction: @escaping () -> Void) {
        self.getGroceriesUseCase = getGroceriesUseCase
        self.ticketModel = ticketModel
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
    
    func saveTicket(for groceryModel: NewTicketView.GroceryModel?, or groceryName: String) {
        let getGrocery: () -> Grocery? = {
            if let model = groceryModel, model != self.auxiliarGrocery {
                return Grocery(id: model.id, name: model.name)
            } else if !groceryName.isEmpty {
                return Grocery(id: UUID(), name: groceryName)
            }
            return nil
        }
        
        let grocery = getGrocery()
        // TODO: call use case
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
