import Foundation
import VisionKit
import Vision

struct TicketAnalyser: Analyser {
    
    private struct TextItem {
        let text: String
        let minX: CGFloat
    }
    
    // The current observation's baseline is within 1% of the previous observation's baseline, it must belong to the current value.
    private let observationBaselineThreshold = 0.01
    
    func analyse(observations: [VNRecognizedTextObservation]) -> String {
        var ticketRows: [String] = []
        var currentTicketRow: [TextItem] = []
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
                   add(textItem: textItem, intoCurrentRow: &currentTicketRow)
               } else {
                   saveCurrentRow(row: &currentTicketRow, into: &ticketRows)
               }
            } 
            
            if currentTicketRow.isEmpty {
                currentTicketRow.append(textItem)
            }
            
            previousObservation = observation
        }
        
        // Store the latest row available
        if !currentTicketRow.isEmpty {
            saveCurrentRow(row: &currentTicketRow, into: &ticketRows)
        }
        
        return ticketRows.joined(separator: "\n")
    }
    
    private func add(textItem: TextItem, intoCurrentRow row: inout [TextItem]) {
        if let index: Int = row.firstIndex(where: { $0.minX > textItem.minX }) {
            row.insert(textItem, at: index)
        } else {
            row.append(textItem)
        }
    }
    
    private func saveCurrentRow(row: inout [TextItem], into rows: inout [String]) {
        let rowString = row.map { $0.text }.joined(separator: "\t")
        rows.append(rowString)
        row.removeAll()
    }
}
