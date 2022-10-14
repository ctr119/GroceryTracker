import SwiftUI

class NewTicketViewModel {
    private(set) var pagesCount: Int = 0
    private(set) var rowsPerPageCount: [Int] = []
    @Binding var modelForDismissal: ScannedTicketModel?
    
    private var ticketModel: ScannedTicketModel
    
    init(ticketModel: ScannedTicketModel, modelForDismissal: Binding<ScannedTicketModel?>) {
        self.ticketModel = ticketModel
        self._modelForDismissal = modelForDismissal
    }
    
    func onAppear() {
        let rows = ticketModel.pages.flatMap { $0.finalRows }
        // TODO: Continue
    }
    
    func displayInformation() {
        pagesCount = ticketModel.pages.count
        rowsPerPageCount = ticketModel.pages.map { $0.getRows().count }
    }
    
    func getRow(at index: Int, ofPage pageIndex: Int) -> [String] {
        ticketModel.pages[pageIndex].row(at: index)
    }
    
    func updateRow(at index: Int, ofPage pageIndex: Int, with newValue: [String]) {
        ticketModel.pages[pageIndex].set(row: newValue, at: index)
    }
    
    func saveTicket(groceryName: String) {
        modelForDismissal = nil
    }
    
    func cancelTicket() {
        modelForDismissal = nil
    }
}
