import SwiftUI

struct ColumnsDistributionView: View {
    @State private var columns: [ColumnsDistribution.Column] = [
        ColumnsDistribution.defaultDistribution.nameColumn,
        ColumnsDistribution.defaultDistribution.unitsColumn,
        ColumnsDistribution.defaultDistribution.singlePriceColumn,
        ColumnsDistribution.defaultDistribution.totalPriceColumn
    ]
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    Section {
                        ForEach(columns, id: \.id) { column in
                            Text(column.name)
                        }
                        .onMove { source, destination in
                            columns.move(fromOffsets: source, toOffset: destination)
                        }
                    } header: {
                        Text("Ticket Columns Distribution")
                    } footer: {
                        Text("Sort them according to yours by 'Drag & Drop'. The one on top will the first.")
                    }
                    .headerProminence(.increased)
                }
                .toolbar {
                    EditButton()
                }
            }
            
            SaveBottomBar {
                // TODO
            } cancelAction: {
                // TODO
            }
        }
    }
}

struct ColumnsDistributionView_Previews: PreviewProvider {
    static var previews: some View {
        ColumnsDistributionView()
    }
}
