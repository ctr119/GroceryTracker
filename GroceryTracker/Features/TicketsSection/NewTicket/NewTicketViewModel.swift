import SwiftUI

class NewTicketViewModel: ObservableObject {
    @Published var rows: [TextPage.Row] = []
    @Binding var modelForDismissal: ScannedTicketModel?
    
    private var ticketModel: ScannedTicketModel
    
    init(ticketModel: ScannedTicketModel, modelForDismissal: Binding<ScannedTicketModel?>) {
        self.ticketModel = ticketModel
        self._modelForDismissal = modelForDismissal
    }
    
    func onAppear() {
        rows = ticketModel.pages.flatMap { $0.finalRows }
    }
    
    func saveTicket(groceryName: String) {
        modelForDismissal = nil
    }
    
    func cancelTicket() {
        modelForDismissal = nil
    }
}
