import Foundation
import Vision

protocol Analyser {
    var maxRecognitionCandidates: Int { get }
    
    func analyse(observations: [VNRecognizedTextObservation]) -> TextPage
}

extension Analyser {
    var maxRecognitionCandidates: Int {
        return 1
    }
}
