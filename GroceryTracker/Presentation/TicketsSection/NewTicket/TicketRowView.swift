import SwiftUI
import UIComponents

struct TicketRowView: View {
    @Binding var row: TextPage.Row
    let didCancel: () -> Void
    
    private let textFieldLineColor = DesignSystem.ColorScheme.Element.primary.color
    
    var body: some View {
        VStack {
            MaterialTextField(placeHolder: "Name",
                              value: $row.name,
                              label: "Name",
                              lineColor: textFieldLineColor,
                              lineHeight: 1)
            
            HStack {
                MaterialTextField(placeHolder: "Price",
                                  value: $row.singlePrice,
                                  label: "Price",
                                  lineColor: textFieldLineColor,
                                  lineHeight: 1)
                
                MaterialTextField(placeHolder: "Units",
                                value: $row.units,
                                label: "Units",
                                lineColor: textFieldLineColor,
                                lineHeight: 1)
                
                MaterialTextField(placeHolder: "Total",
                                value: $row.totalPrice,
                                label: "Total",
                                lineColor: textFieldLineColor,
                                lineHeight: 1)
            }
            
            Divider()
            
            buttonsStack
                .padding(12)
        }
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private var buttonsStack: some View {
        HStack {
            Spacer()
            
            Button(role: .destructive) {
                didCancel()
            } label: {
                Label {
                    Text("Delete item")
                } icon: {
                    Image(systemName: "trash")
                }
            }
            .buttonStyle(.bordered)
            .tint(nil)
        }
    }
}

struct TicketRowView_Previews: PreviewProvider {
    @State static var row = TextPage.Row(name: "Milk",
                                         units: "1",
                                         singlePrice: "4.5",
                                         totalPrice: "4.5")
    
    static var previews: some View {
        ZStack {
            Color.gray
            
            TicketRowView(row: $row, didCancel: {})
        }
        .ignoresSafeArea()
    }
}
