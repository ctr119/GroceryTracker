import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    let columnsDistribution: ColumnsDistribution
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        return documentViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
//        let ticketAnalyser = TicketAnalyser(columnsDistribution: columnsDistribution)
        let ticketAnalyser = TicketAnalyserSimplification()
        let viewModel = ScannerViewModel(textRecogniser: TextRecogniserImplementation(analyser: ticketAnalyser))
        
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
            DispatchQueue.global(qos: .userInitiated).async {
                let scannedTicketModel = self.viewModel.recogniseText(from: scan.getImages())
                
                DispatchQueue.main.async {
                    let rootView = NewTicketView.DI.inject(ticketModel: scannedTicketModel)
                        .navigationBarHidden(true)
                    
                    let hostingController = UIHostingController(rootView: rootView)
                    controller.navigationController?.pushViewController(hostingController, animated: true)
                }
            }
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.navigationController?.popViewController(animated: true)
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
