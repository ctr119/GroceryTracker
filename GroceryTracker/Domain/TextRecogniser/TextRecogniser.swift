import SwiftUI
import VisionKit
import Vision

protocol TextRecogniser {
    func text(from images: [CGImage]) -> [TextPage]
}

struct TextRecogniserImplementation: TextRecogniser {
    private let analyser: Analyser
    
    init(analyser: Analyser) {
        self.analyser = analyser
    }
    
    func text(from images: [CGImage]) -> [TextPage] {
        var pages: [TextPage] = []
        
        let recogniseTextRequest = VNRecognizeTextRequest { request, error in
            guard error == nil else { return }
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            let resultsPage = analyser.analyse(observations: observations)
            pages.append(resultsPage)
        }
        recogniseTextRequest.recognitionLevel = .accurate
        recogniseTextRequest.usesLanguageCorrection = true
        recogniseTextRequest.recognitionLanguages = [
            "es", "en"
        ]
        
        images.forEach {
            let requestHandler = VNImageRequestHandler(cgImage: $0, options: [:])
            try? requestHandler.perform([recogniseTextRequest])
        }
        
        return pages
    }
}
