import SwiftUI

struct TicketsSectionView: View {    
    @State private var scannedTicketModel: ScannedTicketModel?
    @State private var shouldOpenScanner = false
    
    var body: some View {
        ZStack {
            Text("Empty")
            
            FloatingButton(text: "+", style: .basic) {
                shouldOpenScanner = true
            }
        }
        .sheet(isPresented: $shouldOpenScanner) {
            TicketScannerView(scannedTicketModel: $scannedTicketModel)
        }
        .sheet(item: $scannedTicketModel) { ticketModel in
            NewTicketView(viewModel: NewTicketViewModel(ticketModel: ticketModel))
        }
    }
}

struct TicketsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        TicketsSectionView()
    }
}
