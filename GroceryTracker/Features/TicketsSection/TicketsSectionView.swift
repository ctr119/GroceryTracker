import SwiftUI

struct TicketsSectionView: View {    
    @State private var newScannedTicketModel: NewScannedTicketModel?
    @State private var shouldOpenScanner = false
    
    var body: some View {
        ZStack {
            Text("Empty")
            
            FloatingButton(text: "+", style: .basic) {
                shouldOpenScanner = true
            }
        }
        .sheet(isPresented: $shouldOpenScanner) {
            TicketScannerView(newScannedTicketModel: $newScannedTicketModel)
        }
        .sheet(item: $newScannedTicketModel) { ticketModel in
            NewTicketView(ticketModel: ticketModel)
        }
    }
}

struct TicketsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        TicketsSectionView()
    }
}
