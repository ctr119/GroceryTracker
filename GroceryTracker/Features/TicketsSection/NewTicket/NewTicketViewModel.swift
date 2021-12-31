import SwiftUI

struct NewTicketViewModel {
    @Binding var pagesCount: Int?
    @Binding var rowsPerPageCount: [Int]?
    @Binding var modelForDismissal: ScannedTicketModel?
    
    private var ticketModel: ScannedTicketModel
    
    init(ticketModel: ScannedTicketModel,
         pagesCount: Binding<Int?>?,
         rowsPerPageCount: Binding<[Int]?>?,
         modelForDismissal: Binding<ScannedTicketModel?>) {
        self.ticketModel = ticketModel
        self._pagesCount = pagesCount ?? Binding.constant(nil)
        self._rowsPerPageCount = rowsPerPageCount ?? Binding.constant(nil)
        self._modelForDismissal = modelForDismissal
    }
    
    func displayInformation() {
        pagesCount = ticketModel.pages.count
                
        for pIndex in 0..<ticketModel.pages.count {
            rowsPerPageCount?[pIndex] = ticketModel.pages[pIndex].getRows().count
        }
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
