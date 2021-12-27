import Foundation

// TODO: Rename to "ScannedTicketModel"
struct NewScannedTicketModel: Identifiable {
    let id: UUID
    var pages: [TextPage]
}
