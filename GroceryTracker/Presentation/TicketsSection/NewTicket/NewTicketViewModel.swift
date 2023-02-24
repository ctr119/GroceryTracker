import SwiftUI

class NewTicketViewModel: ObservableObject {
    @Published var rows: [TextPage.Row] = []
    
    private var ticketModel: ScannedTicketModel
    private let cancelAction: () -> Void
    
    init(ticketModel: ScannedTicketModel, cancelAction: @escaping () -> Void) {
        self.ticketModel = ticketModel
        self.cancelAction = cancelAction
    }
    
    func onAppear() {
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
