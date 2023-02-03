import Foundation

struct ScannedTicketModel: Identifiable {
    let id: UUID
    var pages: [TextPage]
}
