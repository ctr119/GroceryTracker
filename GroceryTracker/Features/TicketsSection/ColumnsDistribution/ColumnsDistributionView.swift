import SwiftUI

struct ColumnsDistributionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var columns: [ColumnsDistribution.Column.Kind] = [
        .name, .units, .singlePrice, .totalPrice
    ]
    @State private var distribution: ColumnsDistribution?
    @State private var isShowingDetailView = false
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    NavigationLink(isActive: $isShowingDetailView) {
                        if let distribution = distribution {
                            ScannerView(columnsDistribution: distribution)
                                .navigationBarHidden(true)
                        }
                    } label: {
                        EmptyView()
                    }
                    
                    columnsList
                    
                    bottomBar
                }
            }
        }
    }
    
    private var columnsList: some View {
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
    
    private var bottomBar: some View {
        SaveBottomBar {
            var dictionary: [ColumnsDistribution.Column.Kind : Int] = [:]

            for (index, colKind) in columns.enumerated() {
                dictionary[colKind] = index
            }

            guard let namePosition = dictionary[.name],
                  let unitsPosition = dictionary[.units],
                  let singlePricePosition = dictionary[.singlePrice],
                  let totalPricePosition = dictionary[.totalPrice] else { return }
            
            distribution = ColumnsDistribution(namePosition: namePosition,
                                               unitsPosition: unitsPosition,
                                               singlePricePosition: singlePricePosition,
                                               totalPricePosition: totalPricePosition)
            
            isShowingDetailView = true
            
        } cancelAction: {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ColumnsDistributionView_Previews: PreviewProvider {
    @State static var columnsDistribution: ColumnsDistribution? = ColumnsDistribution.defaultDistribution
    
    static var previews: some View {
        ColumnsDistributionView()
    }
}
