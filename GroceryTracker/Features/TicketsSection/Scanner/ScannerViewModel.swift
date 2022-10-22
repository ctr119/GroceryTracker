import Foundation
import SwiftUI

struct ScannerViewModel {
//    @Binding var scannedTicketModel: ScannedTicketModel?
    let textRecogniser: TextRecogniser
    
    func recogniseText(from images: [CGImage]) -> ScannedTicketModel {
        let textPages = textRecogniser.text(from: images)
        return ScannedTicketModel(id: UUID(), pages: textPages)
        
//        DispatchQueue.main.async {
//            self.scannedTicketModel = ScannedTicketModel(id: UUID(), pages: textPages)
//        }
    }
}
