import SwiftUI

public struct FloatingButton: View {
    public enum Style {
        case basic
        case custom(configuration: FBConfiguration)
    }
    
    public struct FBConfiguration {
        public var width: CGFloat = 55
        public var height: CGFloat? = nil
        public var fontSize: CGFloat? = nil
        public var cornerRadius: CGFloat? = nil
        public var background: Color = .blue
        public var tint: Color = .white
    }
    
    private let text: String
    
    private let buttonWidth: CGFloat
    private let buttonHeight: CGFloat
    private let buttonFontSize: CGFloat
    private let buttonCornerRadius: CGFloat
    
    private let backgroundColor: Color
    private let tintColor: Color
    
    private let didTapAction: () -> Void
    
    public init(text: String, style: FloatingButton.Style, didTapAction: @escaping () -> Void) {
        self.text = text
        
        var config: FBConfiguration
        switch style {
        case .basic:
            config = FBConfiguration()
            
        case .custom(let configuration):
            config = configuration
        }
        
        buttonWidth = config.width
        
        buttonHeight = config.height ?? buttonWidth - 7
        buttonFontSize = config.fontSize ?? buttonWidth / 2
        buttonCornerRadius = config.cornerRadius ?? buttonWidth / 2
        
        backgroundColor = config.background
        tintColor = config.tint
        
        self.didTapAction = didTapAction
    }
    
    public var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: didTapAction) {
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
        
        func makeBody(configuration: Configuration) -> some View {
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
        FloatingButton(text: "+", style: .basic, didTapAction: {
            // Here go the action
        })
    }
}