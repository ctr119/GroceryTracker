import Foundation
import VisionKit
import Vision

struct SimpleListAnalyser: Analyser {
    func analyse(observations: [VNRecognizedTextObservation]) -> String {
        return observations
            .compactMap { $0.topCandidates(self.maxRecognitionCandidates).first?.string }
            .joined(separator: "\n")
    }
}
