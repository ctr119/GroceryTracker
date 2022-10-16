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
            ColumnsDistributionView()
//            ScannerView(scannedTicketModel: $scannedTicketModel)
        }
        .fullScreenCover(item: $scannedTicketModel) { ticketModel in
            let viewModel = NewTicketViewModel(ticketModel: ticketModel,
                                               modelForDismissal: $scannedTicketModel)
            
            NewTicketView(viewModel: viewModel)
        }
    }
}

struct TicketsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        TicketsSectionView()
    }
}
