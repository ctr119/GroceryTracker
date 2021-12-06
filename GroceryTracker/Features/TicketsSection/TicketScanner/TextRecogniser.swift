import SwiftUI
import VisionKit
import Vision

protocol TextRecogniser {
    func text(from images: [CGImage]) -> String
}

struct TextRecogniserImplementation: TextRecogniser {
    private let maxRecognitionCandidates = 1
    
    func text(from images: [CGImage]) -> String {
        var entireRecognisedText: String = ""
        
        let recogniseTextRequest = VNRecognizeTextRequest { request, error in
            guard error == nil else { return }
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            observations
                .compactMap { $0.topCandidates(self.maxRecognitionCandidates).first?.string }
                .forEach {
                    print("Candidate: \($0)")
                    entireRecognisedText += "\($0)\n"
                }
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
        
        return entireRecognisedText
    }
}
