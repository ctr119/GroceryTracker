import SwiftUI

struct NewTicketView: View {
    @State private var pagesCount: Int = 1
    @State private var rowsPerPageCount: [Int] = [2]
    
    let viewModel: NewTicketViewModel
    
    init(ticketModel: ScannedTicketModel) {
        viewModel = NewTicketViewModel(ticketModel: ticketModel,
                                       pagesCount: nil,
                                       rowsPerPageCount: nil)
        
        viewModel.pagesCount = pagesCount
        viewModel.rowsPerPageCount = rowsPerPageCount
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach((0...pagesCount-1), id: \.self) { pageIndex in
                    ForEach((0...rowsPerPageCount[pageIndex]-1), id: \.self) { rowIndex in
                        
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
        .onAppear {
            viewModel.displayInformation()
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
