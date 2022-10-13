import Foundation
import SwiftUI

struct TicketScannerViewModel {
    @Binding var scannedTicketModel: ScannedTicketModel?
    let textRecogniser: TextRecogniser
    
    func recogniseText(from images: [CGImage]) {
        let textPages = textRecogniser.text(from: images)
        
        DispatchQueue.main.async {
            self.scannedTicketModel = ScannedTicketModel(id: UUID(), pages: textPages)
        }
    }
}
