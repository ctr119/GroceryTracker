import Foundation
import SwiftUI

struct TicketScannerViewModel {
    @Binding var scannedTicketModel: ScannedTicketModel?
    let textRecogniser: TextRecogniser
    
    func recogniseText(from images: [CGImage]) {
        let textPages = textRecogniser.text(from: images)
        scannedTicketModel = ScannedTicketModel(id: UUID(), pages: textPages)
    }
}
