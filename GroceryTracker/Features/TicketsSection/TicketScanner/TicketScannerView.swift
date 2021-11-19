import SwiftUI
import VisionKit

struct TicketScannerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var recognisedText: String
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recognisedText: $recognisedText,
                    textRecogniser: TextRecogniserImplementation(),
                    parent: self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private var recognisedText: Binding<String>
        private let textRecogniser: TextRecogniser
        private let parent: TicketScannerView
        
        init(recognisedText: Binding<String>,
             textRecogniser: TextRecogniser,
             parent: TicketScannerView) {
            self.recognisedText = recognisedText
            self.textRecogniser = textRecogniser
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let images = scan.getImages()
            recognisedText.wrappedValue = textRecogniser.recognise(from: images)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

extension VNDocumentCameraScan {
    func getImages() -> [CGImage] {
        var images: [CGImage] = []
        
        for pageIndex in 0..<self.pageCount {
            let image = imageOfPage(at: pageIndex)
            guard let cgImage = image.cgImage else { continue }
            images.append(cgImage)
        }
        
        return images
    }
}
