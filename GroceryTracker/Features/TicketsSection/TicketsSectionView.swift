import SwiftUI

struct TicketsSectionView: View {    
    @State private var shouldRequestColumnDistribution = false
    @State private var selectedColumnsDistribution: ColumnsDistribution?
    @State private var scannedTicketModel: ScannedTicketModel?
    
    var body: some View {
        ZStack {
            Text("Empty")
            
            FloatingButton(text: "+", style: .basic) {
                shouldRequestColumnDistribution = true
            }
        }
        .sheet(isPresented: $shouldRequestColumnDistribution,
               onDismiss: {
            shouldRequestColumnDistribution = false
        }) {
            ColumnsDistributionView(columnsDistribution: $selectedColumnsDistribution)
        }
        .sheet(item: $selectedColumnsDistribution) { columnsDistribution in
            ScannerView(scannedTicketModel: $scannedTicketModel,
                        columnsDistribution: columnsDistribution)
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
