import SwiftUI

public struct FloatingButton: View {
    public enum Style {
        case basic
        case custom(configuration: FBConfiguration)
    }
    
    public struct FBConfiguration {
        public struct Border {
            public let color: Color
            public let lineWidth: CGFloat
            
            public init(color: Color, lineWidth: CGFloat) {
                self.color = color
                self.lineWidth = lineWidth
            }
        }
        
        public var width: CGFloat
        public var height: CGFloat?
        public var fontSize: CGFloat?
        public var cornerRadius: CGFloat?
        public var background: Color
        public var tint: Color
        public let border: Border?
        
        public init(width: CGFloat = 55,
                    height: CGFloat? = nil,
                    fontSize: CGFloat? = nil,
                    cornerRadius: CGFloat? = nil,
                    background: Color = .blue,
                    tint: Color = .white,
                    border: Border? = nil) {
            self.width = width
            self.height = height
            self.fontSize = fontSize
            self.cornerRadius = cornerRadius
            self.background = background
            self.tint = tint
            self.border = border
        }
    }
    
    private let iconName: String
    
    private let buttonWidth: CGFloat
    private let buttonHeight: CGFloat
    private let buttonFontSize: CGFloat
    private let buttonCornerRadius: CGFloat
    
    private let backgroundColor: Color
    private let tintColor: Color
    
    private let border: FBConfiguration.Border?
    
    private let didTapAction: () -> Void
    
    public init(iconName: String,
                style: FloatingButton.Style,
                didTapAction: @escaping () -> Void) {
        
        self.iconName = iconName
        
        var config: FBConfiguration
        switch style {
        case .basic:
            config = FBConfiguration()
            
        case .custom(let configuration):
            config = configuration
        }
        
        buttonWidth = config.width
        
        buttonHeight = config.height ?? buttonWidth
        buttonFontSize = config.fontSize ?? buttonWidth / 2.5
        buttonCornerRadius = config.cornerRadius ?? buttonWidth / 2
        
        backgroundColor = config.background
        tintColor = config.tint
        
        border = config.border
        
        self.didTapAction = didTapAction
    }
    
    public var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: didTapAction) {
                    buttonLayout
                }
                .buttonStyle(FloatingButtonStyle(buttonBackgroundColor: backgroundColor,
                                                 buttonCornerRadius: buttonCornerRadius,
                                                 border: border))
            }
        }
    }
    
    private var buttonLayout: some View {
        Image(systemName: iconName)
            .font(.system(size: buttonFontSize))
            .frame(width: buttonWidth,
                   height: buttonHeight,
                   alignment: .center)
            .foregroundColor(tintColor)
    }
    
    private struct FloatingButtonStyle: ButtonStyle {
        let buttonBackgroundColor: Color
        let buttonCornerRadius: CGFloat
        let border: FBConfiguration.Border?
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(configuration.isPressed ? buttonBackgroundColor.opacity(0.6) : buttonBackgroundColor)
                .cornerRadius(buttonCornerRadius)
                .shadow(color: .black.opacity(0.3),
                        radius: 3, x: 3, y: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: buttonCornerRadius)
                        .stroke(border?.color ?? .clear,
                                lineWidth: border?.lineWidth ?? 0)
                )
                .padding()
        }
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FloatingButton(iconName: "plus", style: .basic, didTapAction: {
                // Here go the action
            })
            
            FloatingButton(iconName: "plus",
                           style: .custom(configuration: .init(width: 80,
                                                               height: 80,
                                                               fontSize: 70,
                                                               cornerRadius: 10,
                                                               background: .red,
                                                               tint: .white)),
                           didTapAction: {
                // Here go the action
            })
            
            FloatingButton(iconName: "plus",
                           style: .custom(configuration: .init(width: 80,
                                                               height: 80,
                                                               cornerRadius: 25,
                                                               background: .red,
                                                               tint: .white,
                                                               border: .init(color: .blue,
                                                                             lineWidth: 2))),
                           didTapAction: {
                // Here go the action
            })
            
            FloatingButton(iconName: "plus",
                           style: .custom(configuration: .init(width: 80,
                                                               height: 80,
                                                               cornerRadius: 10,
                                                               background: .red,
                                                               tint: .white)),
                           didTapAction: {
                // Here go the action
            })
        }
    }
}
