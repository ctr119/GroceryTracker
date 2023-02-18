import SwiftUI

struct EmptyErrorView: View {
    struct CTAButtonConfig {
        let text: String
        let action: () -> Void
    }
    
    let message: String
    var buttonConfig: CTAButtonConfig? = nil
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 25) {
                            getErrorImage(geometry: geometry)
                            
                            Text(message)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                        }
                                    
                        if let buttonConfig = buttonConfig {
                            getActionButton(config: buttonConfig)
                        }
                        
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .foregroundColor(DesignSystem.ColorScheme.Element.secondary.color)
        .padding()
    }
    
    private func getErrorImage(geometry: GeometryProxy) -> some View {
        let imageWidth = geometry.size.width / 3
        let imageHeight = geometry.size.height / 6
        
        return Image(systemName: "exclamationmark.triangle.fill")
            .resizable()
            .frame(width: imageWidth, height: imageHeight)
            .frame(maxWidth: 120, maxHeight: 100)
    }
    
    private func getActionButton(config: CTAButtonConfig) -> some View {
        VStack {
            Button {
                config.action()
            } label: {
                Text(config.text)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 12)
            .background(DesignSystem.ColorScheme.Element.secondary.color)
            .foregroundColor(DesignSystem.ColorScheme.Semantic.accent.color)
            .clipShape(Capsule())
            .padding(.top, 30)
        }
    }
}

struct EmptyErrorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmptyErrorView(message: "Oops! Something went wrong... Try the button down below", buttonConfig: .init(text: "Press me", action: {
                print("Hello!")
            }))
            .previewDisplayName("With Button")
            
            EmptyErrorView(message: "Oops! Something went wrong...")
                .previewDisplayName("Without Button")
        }
    }
}
