import Foundation
import SwiftUI

struct TicketScannerViewModel {
    @Binding var recognisedText: String
    let textRecogniser: TextRecogniser
    
    func recogniseText(from images: [CGImage]) {
        recognisedText = textRecogniser.text(from: images)
    }
}
