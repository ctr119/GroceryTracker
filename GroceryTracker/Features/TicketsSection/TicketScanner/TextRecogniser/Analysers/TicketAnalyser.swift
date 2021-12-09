import Foundation
import VisionKit
import Vision

private struct TextItem {
    let text: String
    let minX: CGFloat
}

struct TicketAnalyser: Analyser {
    // The current observation's baseline is within 1% of the previous observation's baseline, it must belong to the current value.
    let observationBaselineThreshold = 0.01
    
    func analyse(observations: [VNRecognizedTextObservation]) -> String {
        var entryRows: [String] = []
        var currentEntry: [TextItem] = []
        var previousObservation: VNRecognizedTextObservation?
        let sortedObservations = observations.sorted(by: { lhs, rhs in
            lhs.boundingBox.minY > rhs.boundingBox.minY
        })
        
        for observation in sortedObservations {
            guard let candidate = observation.topCandidates(maxRecognitionCandidates).first,
                  (candidate.string.isUppercased()
                   || candidate.string.contains("kg")) else { continue }
            
            let textItem = TextItem(text: candidate.string, minX: observation.boundingBox.minX)
            
            if let previous = previousObservation {
               if abs(observation.boundingBox.minY - previous.boundingBox.minY) < observationBaselineThreshold {
                   if let index: Int = currentEntry.firstIndex(where: { $0.minX > textItem.minX }) {
                       currentEntry.insert(textItem, at: index)
                   } else {
                       currentEntry.append(textItem)
                   }
                   
               } else {
                   let row = currentEntry.map { $0.text }.joined(separator: "\t")
                   entryRows.append(row)
                   currentEntry.removeAll()
               }
            } 
            
            if currentEntry.isEmpty {
                currentEntry.append(textItem)
            }
            
            previousObservation = observation
        }
        
        return entryRows.joined(separator: "\n")
    }
}
