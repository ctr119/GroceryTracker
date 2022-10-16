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
                            HStack {
                                Text(column.name)
                                Spacer()
                                Image(systemName: "line.3.horizontal")
                            }
                            .onDrag {
                                return NSItemProvider(item: nil, typeIdentifier: nil)
                            }
                        }
                        // NOTE: List doesn’t support the onDrop modifier
                        .onMove { source, destination in
                            columns.move(fromOffsets: source, toOffset: destination)
                        }
                    } footer: {
                        Text("Distribute them according to your ticket by \"Drag & Drop\". The one on top will be the first.")
                    }
                }
                .navigationTitle("Ticket Columns")
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
