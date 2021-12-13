import SwiftUI

struct TicketsSectionView: View {
    struct NewScannedTicketModel: Identifiable {
        let id: UUID
        let text: String
    }
    
    @State private var newScannedTicketModel: NewScannedTicketModel?
    @State private var shouldOpenScanner = false
    
    var body: some View {
        ZStack {
            Text("TODO: List here all the tickets")
            
            FloatingButton(text: "+", style: .basic) {
                shouldOpenScanner = true
            }
        }
        .sheet(isPresented: $shouldOpenScanner) {
            TicketScannerView(newScannedTicketModel: $newScannedTicketModel)
        }
        .sheet(item: $newScannedTicketModel) { ticketModel in
            NewTicketView()
        }
    }
}

struct TicketsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        TicketsSectionView()
    }
}
