import Foundation
import SwiftUI

struct ScannerViewModel {
    let textRecogniser: TextRecogniser
    
    func recogniseText(from images: [CGImage]) -> ScannedTicketModel {
        let textPages = textRecogniser.text(from: images)
        return ScannedTicketModel(id: UUID(), pages: textPages)
    }
}
