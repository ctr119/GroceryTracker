import SwiftUI
import UIComponents

struct FoodSectionView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                FoodListView(searchText: searchText)
                
                SearchBarView(text: $searchText)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
    }
}

struct FoodSection_Previews: PreviewProvider {
    static var previews: some View {
        FoodSectionView()
    }
}
