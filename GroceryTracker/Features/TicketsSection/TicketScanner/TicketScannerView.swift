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
        let viewModel = TicketScannerViewModel(recognisedText: $recognisedText,
                                               textRecogniser: TextRecogniserImplementation(analyser: TicketAnalyser()))
        
        return Coordinator(viewModel: viewModel, parent: self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let viewModel: TicketScannerViewModel
        private let parent: TicketScannerView
        
        init(viewModel: TicketScannerViewModel,
             parent: TicketScannerView) {
            self.viewModel = viewModel
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            // TODO: in the end, the text should be managed and stored in a DB, not passed to the UI
            viewModel.recogniseText(from: scan.getImages())
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
