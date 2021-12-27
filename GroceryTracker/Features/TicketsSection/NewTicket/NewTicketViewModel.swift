import SwiftUI

struct NewTicketViewModel {
    private var ticketModel: ScannedTicketModel
    
    init(ticketModel: ScannedTicketModel) {
        self.ticketModel = ticketModel
    }
    
    func getPagesCount() -> Int {
        ticketModel.pages.count
    }
    
    func getRowsCount(of pageIndex: Int) -> Int {
        ticketModel.pages[pageIndex].getRows().count
    }
    
    func getRow(at index: Int, ofPage pageIndex: Int) -> [String] {
        ticketModel.pages[pageIndex].row(at: index)
    }
    
    func updateRow(at index: Int, ofPage pageIndex: Int, with newValue: [String]) {
        ticketModel.pages[pageIndex].set(row: newValue, at: index)
    }
}
