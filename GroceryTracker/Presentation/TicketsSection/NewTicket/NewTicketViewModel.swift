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
    
    func saveTicket(groceryName: String) {
        // TODO: Save on Disk
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
