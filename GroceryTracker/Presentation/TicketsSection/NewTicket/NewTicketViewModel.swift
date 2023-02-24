import SwiftUI

class NewTicketViewModel: ObservableObject {
    @Published var rows: [TextPage.Row] = []
    
    private var ticketModel: ScannedTicketModel
    private let didCancel: () -> Void
    
    init(ticketModel: ScannedTicketModel, didCancel: @escaping () -> Void) {
        self.ticketModel = ticketModel
        self.didCancel = didCancel
    }
    
    func onAppear() {
        rows = ticketModel.pages.flatMap { $0.rows }
    }
    
    func saveTicket(groceryName: String) {
        // TODO: Save on Disk
    }
    
    func cancelTicket() {
        didCancel()
    }
    
    func removeItem(index: Int) {
        guard index < rows.count else { return }
        rows.remove(at: index)
    }
}
