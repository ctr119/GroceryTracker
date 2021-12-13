import Foundation
import SwiftUI

struct NewScannedTicketModel: Identifiable {
    let id: UUID
    let text: String
}

struct TicketScannerViewModel {
    @Binding var scannedTicketModel: NewScannedTicketModel?
    let textRecogniser: TextRecogniser
    
    func recogniseText(from images: [CGImage]) {
        let recognisedText = textRecogniser.text(from: images)
        scannedTicketModel = NewScannedTicketModel(id: UUID(), text: recognisedText)
    }
}
