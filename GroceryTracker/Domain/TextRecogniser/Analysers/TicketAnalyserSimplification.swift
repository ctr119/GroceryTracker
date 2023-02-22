import Foundation
import VisionKit
import Vision

struct TicketAnalyserSimplification: Analyser {
    
    private struct TextItem {
        let text: String
        let minX: CGFloat
    }
    
    // The current observation's baseline is within 4% of the previous observation's baseline,
    // it must belong to the current value.
    private let observationBaselineThreshold = 0.04
    
    func analyse(observations: [VNRecognizedTextObservation]) -> TextPage {
        let page = TextPage()
        var currentRow = ""
        var previousObservation: VNRecognizedTextObservation?
        
        for obs in observations {
            guard let candidate = obs.topCandidates(maxRecognitionCandidates).first else { continue }
            
            let textItem = TextItem(text: candidate.string, minX: obs.boundingBox.minX)
            
            if let previous = previousObservation {
                let belongsToSameBaseline = abs(obs.boundingBox.minY - previous.boundingBox.minY) < observationBaselineThreshold
                
                if belongsToSameBaseline {
                    currentRow += " " + textItem.text
                } else {
                    if let row = buildRow(from: currentRow) {
                        page.add(row: row)
                    }
                    currentRow = ""
                }
            }
            
            if currentRow.isEmpty {
                currentRow = textItem.text
            }
            
            previousObservation = obs
        }
        
        if !currentRow.isEmpty, let row = buildRow(from: currentRow) {
            page.add(row: row)
        }
        
        return page
    }
    
    private func buildRow(from rowString: String) -> TextPage.Row? {
        let decimals = rowString
            .components(separatedBy: " ")
            .compactMap { Double($0) }
            .filter { $0.truncatingRemainder(dividingBy: 1) != 0 }
        
        guard let price = decimals.min(),
              let totalPrice = decimals.max() else { return nil }
        
        let quantity = Int(totalPrice / price)
        
        let name = rowString
            .components(separatedBy: .letters.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        
        let priceString = String(price)
        let totalString = String(totalPrice)
        let quantityString = String(quantity)
        
        return TextPage.Row(name: name,
                            units: quantityString,
                            singlePrice: priceString,
                            totalPrice: totalString)
    }
}
