import SwiftUI

struct ColumnsDistributionView: View {
    @State private var columns: [ColumnsDistribution.Column.Kind] = [
        .name, .units, .singlePrice, .totalPrice
    ]
    
    @Binding var columnsDistribution: ColumnsDistribution?
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    Section {
                        ForEach(columns, id: \.self) { columnKind in
                            HStack {
                                Text(columnKind.rawValue)
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
                var dictionary: [ColumnsDistribution.Column.Kind : Int] = [:]
                
                for (index, colKind) in columns.enumerated() {
                    dictionary[colKind] = index
                }
                
                guard let namePosition = dictionary[.name],
                      let unitsPosition = dictionary[.units],
                      let singlePricePosition = dictionary[.singlePrice],
                      let totalPricePosition = dictionary[.totalPrice] else { return }
                
                columnsDistribution = ColumnsDistribution(namePosition: namePosition,
                                                          unitsPosition: unitsPosition,
                                                          singlePricePosition: singlePricePosition,
                                                          totalPricePosition: totalPricePosition)
            } cancelAction: {
                columnsDistribution = nil
            }
        }
    }
}

struct ColumnsDistributionView_Previews: PreviewProvider {
    @State static var columnsDistribution: ColumnsDistribution? = ColumnsDistribution.defaultDistribution
    
    static var previews: some View {
        ColumnsDistributionView(columnsDistribution: $columnsDistribution)
    }
}
