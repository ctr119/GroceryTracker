import SwiftUI

class NewTicketViewModel: ObservableObject {
    @Published var rows: [TextPage.Row] = []
    
    private var ticketModel: ScannedTicketModel
    
    init(ticketModel: ScannedTicketModel) {
        self.ticketModel = ticketModel
    }
    
    func onAppear() {
        rows = ticketModel.pages.flatMap { $0.rows }
    }
    
    func saveTicket(groceryName: String) {
        // TODO: Save on Disk
    }
    
    func cancelTicket() {
        // TODO: Dismiss
    }
}
