import SwiftUI
import UIComponents

struct TicketsSectionView: View {    
    @State private var shouldOpenScanner = false
    @State private var scannedTicketModel: ScannedTicketModel?
    
    var body: some View {
        ZStack {
            // TODO: Load tickets from Disk
            Text("Empty")
            
            FloatingButton(text: "+",
                           style: .custom(configuration: FloatingButton.FBConfiguration(
                            background: DesignSystem.ColorScheme.Element.secondary.color,
                            tint: DesignSystem.ColorScheme.Semantic.accent.color
                           ))) {
                shouldOpenScanner = true
            }
        }
        .sheet(isPresented: $shouldOpenScanner, onDismiss: {
            shouldOpenScanner = false
        }) {
            ScannerView()
        }
    }
}

struct TicketsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        TicketsSectionView()
    }
}
