import Foundation
import VisionKit
import Vision

struct SimpleListAnalyser: Analyser {
    func analyse(observations: [VNRecognizedTextObservation]) -> TextPage {
        let textPage = TextPage()
        
        textPage.addRow(observations
                            .compactMap { $0.topCandidates(self.maxRecognitionCandidates).first?.string })
        
        return textPage
    }
}
