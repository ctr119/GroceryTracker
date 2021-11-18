import SwiftUI

struct FloatingButton: View {
    enum Style {
        case basic
        case custom(configuration: Configuration)
    }
    
    struct Configuration {
        var width: CGFloat = 55
        var height: CGFloat? = nil
        var fontSize: CGFloat? = nil
        var cornerRadius: CGFloat? = nil
        var background: Color = .blue
        var tint: Color = .white
    }
    
    private let text: String
    
    private let buttonWidth: CGFloat
    private let buttonHeight: CGFloat
    private let buttonFontSize: CGFloat
    private let buttonCornerRadius: CGFloat
    
    private let backgroundColor: Color
    private let tintColor: Color
    
    init(text: String, style: FloatingButton.Style) {
        self.text = text
        
        var config: Configuration
        switch style {
        case .basic:
            config = Configuration()
            
        case .custom(let configuration):
            config = configuration
        }
        
        buttonWidth = config.width
        
        buttonHeight = config.height ?? buttonWidth - 7
        buttonFontSize = config.fontSize ?? buttonWidth / 2
        buttonCornerRadius = config.cornerRadius ?? buttonWidth / 2
        
        backgroundColor = config.background
        tintColor = config.tint
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    
                } label: {
                    Text(text)
                        .font(.system(size: buttonFontSize))
                        .frame(width: buttonWidth,
                               height: buttonHeight,
                               alignment: .center)
                        .foregroundColor(tintColor)
                        .padding(.bottom, 7)
                }
                .buttonStyle(FloatingButtonStyle(buttonBackgroundColor: backgroundColor,
                                                 buttonCornerRadius: buttonCornerRadius))
            }
        }
    }
    
    private struct FloatingButtonStyle: ButtonStyle {
        let buttonBackgroundColor: Color
        let buttonCornerRadius: CGFloat
        
        func makeBody(configuration: FloatingButtonStyle.Configuration) -> some View {
            configuration.label
                .background(configuration.isPressed ? buttonBackgroundColor.opacity(0.6) : buttonBackgroundColor)
                .cornerRadius(buttonCornerRadius)
                .padding()
                .shadow(color: .black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
        }
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton(text: "+", style: .basic)
    }
}
