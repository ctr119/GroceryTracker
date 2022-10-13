import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var scannedTicketModel: ScannedTicketModel?
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        let viewModel = ScannerViewModel(scannedTicketModel: $scannedTicketModel,
                                         textRecogniser: TextRecogniserImplementation(analyser: TicketAnalyser()))
        
        return Coordinator(viewModel: viewModel, parent: self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let viewModel: ScannerViewModel
        private let parent: ScannerView
        
        init(viewModel: ScannerViewModel,
             parent: ScannerView) {
            self.viewModel = viewModel
            self.parent = parent
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true) {
                DispatchQueue.global(qos: .userInitiated).async {
                    self.viewModel.recogniseText(from: scan.getImages())
                }
            }
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
