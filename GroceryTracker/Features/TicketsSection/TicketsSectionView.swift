import SwiftUI

struct TicketsSectionView: View {
    var body: some View {
        ZStack {
            FloatingButton(text: "+", style: .basic)
        }
    }
}

struct TicketsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        TicketsSectionView()
    }
}
