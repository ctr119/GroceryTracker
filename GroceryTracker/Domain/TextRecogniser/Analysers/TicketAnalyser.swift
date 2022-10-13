import Foundation
import VisionKit
import Vision

struct TicketAnalyser: Analyser {
    
    private struct TextItem {
        let text: String
        let minX: CGFloat
    }
    
    // The current observation's baseline is within 1.8% of the previous observation's baseline,
    // it must belong to the current value.
    private let observationBaselineThreshold = 0.018
    
    func analyse(observations: [VNRecognizedTextObservation]) -> TextPage {
        let page = TextPage()
        
        var currentTicketRow: [TextItem] = []
        var previousObservation: VNRecognizedTextObservation?
        
        for obs in observations {
            guard let candidate = obs.topCandidates(maxRecognitionCandidates).first else { continue }
            
            let textItem = TextItem(text: candidate.string, minX: obs.boundingBox.minX)
            
            if let previous = previousObservation {
                let belongsToSameBaseline = abs(obs.boundingBox.minY - previous.boundingBox.minY) < observationBaselineThreshold
                
                if belongsToSameBaseline {
                    add(textItem: textItem, intoCurrentRow: &currentTicketRow)
                } else {
                    page.addRow(currentTicketRow.map { $0.text })
                    currentTicketRow.removeAll()
                }
            }
            
            if currentTicketRow.isEmpty {
                currentTicketRow.append(textItem)
            }
            
            previousObservation = obs
        }
        
        if !currentTicketRow.isEmpty {
            page.addRow(currentTicketRow.map { $0.text })
        }
        
        return page
    }
    
    private func add(textItem: TextItem, intoCurrentRow row: inout [TextItem]) {
        if let index: Int = row.firstIndex(where: { $0.minX > textItem.minX }) {
            row.insert(textItem, at: index)
        } else {
            row.append(textItem)
        }
    }
}
