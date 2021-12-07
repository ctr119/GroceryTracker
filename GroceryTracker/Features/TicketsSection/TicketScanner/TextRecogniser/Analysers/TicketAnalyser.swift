import Foundation
import VisionKit
import Vision

struct TicketAnalyser: Analyser {
    // The current observation's baseline is within 1% of the previous observation's baseline, it must belong to the current value.
    let observationBaselineThreshold = 0.01
    
    func analyse(observations: [VNRecognizedTextObservation]) -> String {
        var rows: [String] = []
        var currentRow: String = ""
        var previousObservation: VNRecognizedTextObservation?
        let sortedObservations = observations.sorted(by: { lhs, rhs in
            lhs.boundingBox.minY > rhs.boundingBox.minY
        })
        
        for observation in sortedObservations {
            guard let candidate = observation.topCandidates(maxRecognitionCandidates).first,
                  (candidate.string.isUppercased()
                   || candidate.string.contains("kg")) else { continue }
            
            if let previous = previousObservation {
               if abs(observation.boundingBox.minY - previous.boundingBox.minY) < observationBaselineThreshold {
                   currentRow += "\t\(candidate.string)"
                   
               } else {
                   rows.append(currentRow)
                   currentRow = ""
               }
            } 
            
            if currentRow.isEmpty {
                currentRow = candidate.string
            }
            
            previousObservation = observation
        }
        
        return rows.joined(separator: "\n")
    }
}
