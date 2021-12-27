import Foundation
import SwiftUI

struct TicketScannerViewModel {
    @Binding var scannedTicketModel: NewScannedTicketModel?
    let textRecogniser: TextRecogniser
    
    func recogniseText(from images: [CGImage]) {
        let textPages = textRecogniser.text(from: images)
        scannedTicketModel = NewScannedTicketModel(id: UUID(), pages: textPages)
    }
}
