import SwiftUI

struct NewTicketView: View {
    @State private var groceryName: String = ""
    
    private let viewModel: NewTicketViewModel
    
    init(viewModel: NewTicketViewModel) {
        self.viewModel = viewModel
        
        self.viewModel.displayInformation()
    }
    
    var body: some View {
        VStack {
            CustomTextField(placeHolder: "Grocery's Name",
                            value: $groceryName,
                            lineColor: .gray,
                            lineHeight: 1)
            
            Divider()
            
            ScrollView {
                VStack {
                    ForEach((0...viewModel.pagesCount-1), id: \.self) { pageIndex in
                        ForEach((0...viewModel.rowsPerPageCount[pageIndex]-1), id: \.self) { rowIndex in
                            
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
            
            Divider()
            
            
            SaveBottomBar {
                viewModel.saveTicket(groceryName: groceryName)
            } cancelAction: {
                viewModel.cancelTicket()
            }
        }
    }
}

struct NewTicketView_Previews: PreviewProvider {
    @State static var model: ScannedTicketModel? = ScannedTicketModel(id: UUID(),
                                                                           pages: [getPage()])
    static func getPage() -> TextPage {
        let page = TextPage()
        page.addRow(["Lemon", "Juice"])
        page.addRow(["Orange", "Juice", "Tasty"])
        return page
    }
    
    static var previews: some View {
        NewTicketView(viewModel: NewTicketViewModel(ticketModel: model!,
                                                    modelForDismissal: $model))
    }
}
