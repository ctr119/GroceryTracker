import Foundation

extension String {
    func isUppercased() -> Bool {
        return self.allSatisfy {
            $0.isUppercase
            || $0.isNumber
            || $0.isWhitespace
            || $0.isPunctuation
            || $0.isCurrencySymbol
        }
    }
}
