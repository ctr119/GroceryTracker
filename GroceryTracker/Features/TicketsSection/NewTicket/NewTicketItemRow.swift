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

// TODO: Extract into a new file in UIElements
struct CustomTextField: View {
    let placeHolder: String
    @Binding var value: String
    
    var lineColor: Color
    var lineHeight: CGFloat
    
    var body: some View {
        VStack {
            TextField(placeHolder, text: $value)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            
            Rectangle()
                .frame(height: lineHeight)
                .foregroundColor(lineColor)
        }
        .padding()
    }
}


struct NewTicketItemRow_Previews: PreviewProvider {
    @State static var itemRow = ["Lemon","Juice","Tasty"]
    
    static var previews: some View {
        NewTicketItemRow(itemRow: $itemRow)
    }
}
