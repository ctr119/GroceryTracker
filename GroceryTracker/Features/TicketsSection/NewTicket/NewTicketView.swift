import SwiftUI

struct NewTicketView: View {
    let viewModel: NewTicketViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach((0...viewModel.getPagesCount()-1), id: \.self) { pageIndex in
                    ForEach((0...viewModel.getRowsCount(of: pageIndex)-1), id: \.self) { rowIndex in
                        
                        let bind = Binding(
                            get: { viewModel.getRow(at: rowIndex, ofPage: pageIndex) },
                            set: { viewModel.updateRow(at: rowIndex, ofPage: pageIndex, with: $0) }
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
        NewTicketView(viewModel: NewTicketViewModel(ticketModel: model))
    }
}
