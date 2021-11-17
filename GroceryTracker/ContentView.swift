import SwiftUI

struct ContentView: View {
    @State private var selectedByDefault = 1
    
    var body: some View {
        TabView(selection: $selectedByDefault) {
            Text("Hello, Stats!")
                .padding()
                .tag(0)
                .tabItem {
                    Label("STATS", systemImage: "chart.bar")
                }
            
            FoodSectionView()
                .tag(1)
                .tabItem {
                    Label("FOOD", systemImage: "magnifyingglass")
                }
            
            Text("Hello, Tickets!")
                .padding()
                .tag(2)
                .tabItem {
                    Label("MY TICKETS", systemImage: "menucard")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}