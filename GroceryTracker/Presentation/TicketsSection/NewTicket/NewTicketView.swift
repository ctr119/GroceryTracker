import SwiftUI
import UIComponents

struct NewTicketView: View {
    @State private var groceryName: String = ""
    @ObservedObject private var viewModel: NewTicketViewModel
    
    init(viewModel: NewTicketViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            MaterialTextField(placeHolder: "Grocery's Name",
                              value: $groceryName,
                              textColor: .white,
                              lineColor: DesignSystem.ColorScheme.Semantic.accent.color,
                              lineHeight: 1)
            
            Divider()
            
            itemList
            
            Divider()
            
            SaveBottomBar {
                viewModel.saveTicket(groceryName: groceryName)
            } cancelAction: {
                viewModel.cancelTicket()
            }
            .background(DesignSystem.ColorScheme.Surface.primary.color.opacity(0.5))
        }
        .background(DesignSystem.ColorScheme.Element.secondary.color)
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    private var itemList: some View {
        ScrollView {
            VStack {
                ForEach(0..<viewModel.rows.count, id: \.self) { rowIndex in
                    let binding = Binding {
                        viewModel.rows[rowIndex]
                    } set: { newValue in
                        viewModel.rows[rowIndex] = newValue
                    }
                    TicketRowView(row: binding) {
                        viewModel.removeItem(index: rowIndex)
                    }
                }
            }
            .padding()
        }
    }
}

extension NewTicketView {
    enum DI {
        static func inject(ticketModel: ScannedTicketModel, didCancel: @escaping () -> Void) -> NewTicketView {
            let viewModel = NewTicketViewModel(ticketModel: ticketModel, didCancel: didCancel)
            return NewTicketView(viewModel: viewModel)
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
        NewTicketView(viewModel: NewTicketViewModel(ticketModel: model!, didCancel: {}))
    }
}
