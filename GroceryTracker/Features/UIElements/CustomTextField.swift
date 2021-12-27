import SwiftUI

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

struct CustomTextField_Previews: PreviewProvider {
    @State static var textValue: String = "Value"
    
    static var previews: some View {
        CustomTextField(placeHolder: "Placeholder",
                        value: $textValue,
                        lineColor: .blue,
                        lineHeight: 2)
    }
}
