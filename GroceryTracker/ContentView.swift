import SwiftUI

struct ContentView: View {
    struct TabPreferenceKey: PreferenceKey {
        static var defaultValue: ContentView.TabIndex.Wrapper?
        
        static func reduce(value: inout ContentView.TabIndex.Wrapper?, nextValue: () -> ContentView.TabIndex.Wrapper?) {
            // left empty
        }
    }
    
    enum TabIndex {
        case stats
        case food
        case tickets
        
        struct Wrapper: Equatable, Identifiable {
            let id: UUID = UUID()
            let tabIndex: TabIndex
            
            static func == (lhs: Wrapper, rhs: Wrapper) -> Bool {
                lhs.id == rhs.id
            }
        }
    }
    @State private var selectedByDefault: TabIndex = .food
    
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
        .onPreferenceChange(TabPreferenceKey.self) { value in
            guard let wrapper = value else { return }
            selectedByDefault = wrapper.tabIndex
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
