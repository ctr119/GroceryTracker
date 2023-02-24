import SwiftUI

public struct MaterialTextField: View {
    let placeHolder: String
    @Binding var value: String
    var label: String?
    
    var textColor: Color
    var placeholderColor: Color
    var lineColor: Color
    var lineHeight: CGFloat
    
    public init(placeHolder: String,
                value: Binding<String>,
                label: String? = nil,
                textColor: Color = .black,
                placeholderColor: Color = .gray,
                lineColor: Color,
                lineHeight: CGFloat) {
        self.placeHolder = placeHolder
        self._value = value
        self.label = label
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.lineColor = lineColor
        self.lineHeight = lineHeight
    }
    
    public var body: some View {
        VStack {
            if let label = label {
                Text(label)
                    .foregroundColor(textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
            }
            
            TextField("", text: $value)
                .foregroundColor(textColor)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .placeholderStyle(isVisible: value.isEmpty,
                                  value: placeHolder,
                                  color: placeholderColor)
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            
            Rectangle()
                .frame(height: lineHeight)
                .foregroundColor(lineColor)
        }
        .padding()
    }
}

private struct PlaceholderStyle: ViewModifier {
    var showPlaceholder: Bool
    var placeholder: String
    var color: Color
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceholder {
                Text(placeholder)
                    .foregroundColor(color.opacity(0.4))
                    .padding(.vertical, -5) // prevents jumps between the placeholder and the value
            }
            
            content
        }
    }
}

private extension View {
    func placeholderStyle(isVisible: Bool, value: String, color: Color) -> some View {
        self.modifier(PlaceholderStyle(showPlaceholder: isVisible,
                                       placeholder: value,
                                       color: color))
    }
}

struct CustomTextField_Previews: PreviewProvider {
    @State static var textValue: String = ""
    
    static var previews: some View {
        MaterialTextField(placeHolder: "Placeholder",
                          value: $textValue,
                          label: "Label",
                          textColor: .green,
                          lineColor: .blue,
                          lineHeight: 2)
    }
}
