import SwiftUI

struct TicketRowView: View {
    @Binding var row: TextPage.Row
    
    var body: some View {
        VStack {
            MaterialTextField(placeHolder: "Name",
                            value: $row.name,
                            label: "Name",
                            lineColor: .blue,
                            lineHeight: 1)
            
            HStack {
                MaterialTextField(placeHolder: "Units",
                                value: $row.units,
                                label: "Units",
                                lineColor: .blue,
                                lineHeight: 1)
                
                MaterialTextField(placeHolder: "Price",
                                value: $row.singlePrice,
                                label: "Price",
                                lineColor: .blue,
                                lineHeight: 1)
                
                MaterialTextField(placeHolder: "Total",
                                value: $row.totalPrice,
                                label: "Total",
                                lineColor: .blue,
                                lineHeight: 1)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
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
            
            TicketRowView(row: $row)
        }
        .ignoresSafeArea()
    }
}
