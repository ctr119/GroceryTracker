import SwiftUI

struct NewTicketItemRow: View {
    @Binding var itemRow: [String]
    
    var body: some View {
        HStack {
            ForEach((0...itemRow.count-1), id: \.self) { index in
                CustomTextField(placeHolder: "Name",
                                value: $itemRow[index],
                                lineColor: .blue,
                                lineHeight: 1)
            }
        }
    }
}

struct NewTicketItemRow_Previews: PreviewProvider {
    @State static var itemRow = ["Lemon","Juice","Tasty"]
    
    static var previews: some View {
        NewTicketItemRow(itemRow: $itemRow)
    }
}
