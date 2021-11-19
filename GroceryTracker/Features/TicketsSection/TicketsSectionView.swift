import SwiftUI

struct TicketsSectionView: View {
    @State var recognisedText: String = "---"
    @State private var shouldOpenScanner = false
    
    var body: some View {
        ZStack {
            Text(recognisedText)
            
            FloatingButton(text: "+", style: .basic) {
                shouldOpenScanner = true
            }
        }
        .sheet(isPresented: $shouldOpenScanner) {
            TicketScannerView(recognisedText: $recognisedText)
        }
    }
}

struct TicketsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        TicketsSectionView(recognisedText: "")
    }
}
