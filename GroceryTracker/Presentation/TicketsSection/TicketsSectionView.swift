import SwiftUI
import UIComponents

struct TicketsSectionView: View {    
    @State private var shouldRequestColumnDistribution = false
    @State private var scannedTicketModel: ScannedTicketModel?
    
    var body: some View {
        ZStack {
            // TODO: Load tickets from Disk
            Text("Empty")
            
            FloatingButton(text: "+", style: .basic) {
                shouldRequestColumnDistribution = true
            }
        }
        .sheet(isPresented: $shouldRequestColumnDistribution,
               onDismiss: {
            shouldRequestColumnDistribution = false
        }) {
            ColumnsDistributionView.DI.inject()
        }
    }
}

struct TicketsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        TicketsSectionView()
    }
}
