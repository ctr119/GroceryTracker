import SwiftUI

struct ContentView: View {
    enum TabIndex {
        case stats, food, tickets
    }
    @State private var selectedByDefault = TabIndex.food
    
    var body: some View {
        TabView(selection: $selectedByDefault) {
            Group {
                Text("Hello, Stats!")
                    .tabItem {
                        Label("STATS", systemImage: "chart.bar")
                    }
                    .tag(TabIndex.stats)
                
                FoodSectionView()
                    .tabItem {
                        Label("FOOD", systemImage: "applelogo")
                    }
                    .tag(TabIndex.food)
                
                TicketsSectionView()
                    .tabItem {
                        Label("MY TICKETS", systemImage: "menucard")
                    }
                    .tag(TabIndex.tickets)
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(DesignSystem.ColorScheme.Surface.primary.uiColor.color,
                               for: .tabBar)
        }
        .tint(DesignSystem.ColorScheme.Semantic.accent.color)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
