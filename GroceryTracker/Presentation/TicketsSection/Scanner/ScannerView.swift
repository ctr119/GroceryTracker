import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let documentViewController = VNDocumentCameraViewController()
        documentViewController.delegate = context.coordinator
        
        let navigationController = UINavigationController(rootViewController: documentViewController)
        navigationController.delegate = context.coordinator
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        let baselineAnalyser = BaselineAnalyser()
        let viewModel = ScannerViewModel(textRecogniser: TextRecogniserImplementation(analyser: baselineAnalyser))
        
        return Coordinator(viewModel: viewModel, parent: self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate, UINavigationControllerDelegate {
        private let viewModel: ScannerViewModel
        private let parent: ScannerView
        
        init(viewModel: ScannerViewModel,
             parent: ScannerView) {
            self.viewModel = viewModel
            self.parent = parent
        }
        
        // MARK: - VNDocumentCameraViewControllerDelegate
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            DispatchQueue.global(qos: .userInitiated).async {
                let scannedTicketModel = self.viewModel.recogniseText(from: scan.getImages())
                
                DispatchQueue.main.async {
                    let rootView = NewTicketView.DI.inject(ticketModel: scannedTicketModel, cancelAction: {
                        controller.navigationController?.dismiss(animated: true)
                    }).toolbar(.visible, for: .navigationBar)
                    
                    let hostingController = UIHostingController(rootView: rootView)
                    controller.navigationController?.pushViewController(hostingController, animated: true)
                }
            }
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }
        
        // MARK: - UINavigationControllerDelegate
        
        func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            if viewController is VNDocumentCameraViewController, viewController.navigationController === navigationController {
                navigationController.setNavigationBarHidden(true, animated: animated)
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
