import Foundation
import SwiftUI
import UIKit

class DesignSystem {
    struct ColorScheme: Hashable {
        enum Element {
            static let primary = ColorScheme(light: .black, dark: .white)
            static let secondary = ColorScheme(light: .darkBlue)
        }
                
        enum Surface {
            static let primary = ColorScheme(light: .darkGrayedBlue)
        }
        
        enum Semantic {
            static let accent = ColorScheme(light: .lightGreen)
        }
        
        private let light: DSColor
        private let dark: DSColor?
        
        private init(light: DSColor, dark: DSColor? = nil) {
            self.light = light
            self.dark = dark
        }
        
        var uiColor: UIColor {
            UIColor { trait in
                trait.userInterfaceStyle == .dark ? dark?.uiColor ?? light.uiColor : light.uiColor
            }
        }
        
        var color: Color {
            self.uiColor.color
        }
    }
    
    struct Gradient {
        static let primary = Gradient(colors: [.white, .darkGrayedBlue])

        private let mColors: [DSColor]

        private init(colors: [DSColor]) {
            self.mColors = colors
        }

        var colors: [Color] {
            self.mColors.map {
                $0.uiColor.color
            }
        }
    }
    
    fileprivate enum DSColor: String, CaseIterable {
        case black = "#151c26"
        case cyan = "#03fff6"
        case darkBlue = "#3b4c66"
        case darkGrayedBlue = "#283446"
        case fancyBlue = "#3BB7FF"
        case lightGreen = "#06FF92"
        case turquoise = "#00CFC8"
        case white = "#ffffff"
        
        var uiColor: UIColor {
            let hex = rawValue
            let r, g, b, a: CGFloat

            if hex.hasPrefix("#") {
                let start = hex.index(hex.startIndex, offsetBy: 1)
                let hexColor = String(hex[start...])

                if hexColor.count == 8 {
                    let scanner = Scanner(string: hexColor)
                    var hexNumber: UInt64 = 0

                    if scanner.scanHexInt64(&hexNumber) {
                        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                        a = CGFloat(hexNumber & 0x000000ff) / 255

                        return UIColor(red: r, green: g, blue: b, alpha: a)
                    }
                    
                } else if hexColor.count == 6 {
                    let scanner = Scanner(string: hexColor)
                    var hexNumber: UInt64 = 0

                    if scanner.scanHexInt64(&hexNumber) {
                        r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
                        g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
                        b = CGFloat(hexNumber & 0x0000FF) / 255

                        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
                    }
                }
            }
            
            print("*** Color not working")
            return .clear
        }
        
        var name: String {
            "\(self)"
        }
    }
}

extension UIColor {
    var color: Color {
        Color(uiColor: self)
    }
    
    func opacity(_ opacity: Double) -> UIColor {
        UIColor(self.color.opacity(opacity))
    }
}

// MARK: - Previews

struct ColorSchemes_Previews: PreviewProvider {
    static var colors: [DesignSystem.ColorScheme] = [
        .Element.primary,
        .Element.secondary,
        
        .Surface.primary,
        
        .Semantic.accent
    ]
    
    static var names: [String] = [
        "Element - Primary",
        "Element - Secondary",
        "Surface - Primary",
        "Semantic - Accent"
    ]
    
    static var previews: some View {
        VStack(alignment: .leading) {
            ForEach(Array(Self.colors.enumerated()), id: \.offset) { index, color in
                makeColorRow(colorName: names[index], color: color.uiColor.color)
            }
        }
        .previewLayout(.fixed(width: 400, height: 680))
    }
}

struct Colors_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            ForEach(DesignSystem.DSColor.allCases, id: \.name) { color in
                makeColorRow(colorName: color.name,
                             color: color.uiColor.color)
            }
        }
        .previewLayout(.fixed(width: 400, height: 680))
    }
}

private func makeColorRow(colorName: String, color: Color) -> some View {
    HStack(spacing: 20) {
        Rectangle()
            .strokeBorder(Color.black, lineWidth: 1)
            .background(Rectangle().foregroundColor(color))
            .frame(width: 60, height: 60)
        
        Text(colorName)
    }
}
