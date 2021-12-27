import SwiftUI

struct NewTicketView: View {
    // @Binding var ticketModel: NewScannedTicketModel?
    var ticketModel: ScannedTicketModel
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach((0...ticketModel.pages.count-1), id: \.self) { pageIndex in
                    ForEach((0...ticketModel.pages[pageIndex].getRows().count-1), id: \.self) { rowIndex in
                        
                        let bind = Binding(
                            get: { ticketModel.pages[pageIndex].row(at: rowIndex) },
                            set: { ticketModel.pages[pageIndex].set(row: $0, at: rowIndex) }
                        )
                        NewTicketItemRow(itemRow: bind)
                    }
                }
            }
            .padding()
        }
    }
}

struct NewTicketView_Previews: PreviewProvider {
    @State static var model: ScannedTicketModel = ScannedTicketModel(id: UUID(),
                                                                           pages: [getPage()])
    static func getPage() -> TextPage {
        let page = TextPage()
        page.addRow(["Lemon", "Juice"])
        page.addRow(["Orange", "Juice", "Tasty"])
        return page
    }
    
    static var previews: some View {
        NewTicketView(ticketModel: model)
    }
}
