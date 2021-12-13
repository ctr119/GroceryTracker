import Foundation
import Vision

protocol Analyser {
    var maxRecognitionCandidates: Int { get }
    
    func analyse(observations: [VNRecognizedTextObservation]) -> String
}

extension Analyser {
    var maxRecognitionCandidates: Int {
        return 1
    }
}
