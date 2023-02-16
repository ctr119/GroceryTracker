import SwiftUI

public struct FloatingButton: View {
    public enum Style {
        case basic
        case custom(configuration: FBConfiguration)
    }
    
    public struct FBConfiguration {
        public var width: CGFloat
        public var height: CGFloat?
        public var fontSize: CGFloat?
        public var cornerRadius: CGFloat?
        public var background: Color
        public var tint: Color
        
        public init(width: CGFloat = 55,
                    height: CGFloat? = nil,
                    fontSize: CGFloat? = nil,
                    cornerRadius: CGFloat? = nil,
                    background: Color = .blue,
                    tint: Color = .white) {
            self.width = width
            self.height = height
            self.fontSize = fontSize
            self.cornerRadius = cornerRadius
            self.background = background
            self.tint = tint
        }
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
        
        buttonHeight = config.height ?? buttonWidth
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
        VStack {
            FloatingButton(text: "+", style: .basic, didTapAction: {
                // Here go the action
            })
            
            FloatingButton(text: "-",
                           style: .custom(configuration: .init(width: 80,
                                                               height: 80,
                                                               fontSize: 60,
                                                               cornerRadius: 10,
                                                               background: .red,
                                                               tint: .white)),
                           didTapAction: {
                // Here go the action
            })
            
            FloatingButton(text: "CONTINUE",
                           style: .custom(configuration: .init(width: 180,
                                                               height: 60,
                                                               fontSize: 18,
                                                               cornerRadius: 10,
                                                               background: .black,
                                                               tint: .white)),
                           didTapAction: {
                // Here go the action
            })
        }
    }
}
