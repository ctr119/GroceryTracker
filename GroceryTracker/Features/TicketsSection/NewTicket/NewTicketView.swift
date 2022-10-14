import SwiftUI

struct NewTicketView: View {
    @State private var groceryName: String = ""
    @ObservedObject private var viewModel: NewTicketViewModel
    
    init(viewModel: NewTicketViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            CustomTextField(placeHolder: "Grocery's Name",
                            value: $groceryName,
                            textColor: .white,
                            lineColor: .blue,
                            lineHeight: 1)
            
            Divider()
            
            ScrollView {
                VStack {
                    ForEach(0..<viewModel.rows.count, id: \.self) { rowIndex in
                        let binding = Binding {
                            viewModel.rows[rowIndex]
                        } set: { newValue in
                            viewModel.rows[rowIndex] = newValue
                        }
                        TicketRowView(row: binding)
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
            .background(Color.white)
        }
        .background(Color.Custom.lightgray)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct NewTicketView_Previews: PreviewProvider {
    @State static var model: ScannedTicketModel? = ScannedTicketModel(id: UUID(),
                                                                           pages: [getPage()])
    static func getPage() -> TextPage {
        let page = TextPage()
        page.addRow(["Lemon", "1.00", "1.5", "1.5"], distribution: .defaultDistribution)
        page.addRow(["Orange", "2.00", "3.5", "7.0"], distribution: .defaultDistribution)
        return page
    }
    
    static var previews: some View {
        NewTicketView(viewModel: NewTicketViewModel(ticketModel: model!,
                                                    modelForDismissal: $model))
    }
}
