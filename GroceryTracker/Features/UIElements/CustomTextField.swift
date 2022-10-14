import SwiftUI

struct CustomTextField: View {
    let placeHolder: String
    @Binding var value: String
    var label: String?
    
    var textColor: Color = .black
    var lineColor: Color
    var lineHeight: CGFloat
    
    var body: some View {
        VStack {
            if let label = label {
                Text(label)
                    .foregroundColor(textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
            }
            
            TextField(placeHolder, text: $value)
                .foregroundColor(textColor)
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
                        label: "Label",
                        textColor: .green,
                        lineColor: .blue,
                        lineHeight: 2)
    }
}
