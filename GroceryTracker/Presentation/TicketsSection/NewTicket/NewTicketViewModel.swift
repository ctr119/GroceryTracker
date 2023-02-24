import SwiftUI

class NewTicketViewModel: ObservableObject {
    @Published var rows: [TextPage.Row] = []
    var groceries: [Grocery] = []
    let auxiliarGrocery = Grocery(id: UUID(), name: "Add a new one...")
    
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
    
    func onAppear() {
        groceries = getGroceriesUseCase() + [auxiliarGrocery]
        rows = ticketModel.pages.flatMap { $0.rows }
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
