import SwiftUI
import UIComponents

struct ColumnsDistributionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var viewModel: ColumnsDistributionViewModel
    
    init(viewModel: ColumnsDistributionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    NavigationLink(isActive: $viewModel.shouldOpenScanner) {
                        ScannerView()
                            .navigationBarHidden(true)
                    } label: {
                        EmptyView()
                    }
                    
                    columnsList
                    
                    SaveBottomBar {
                        viewModel.saveCurrentDistribution()
                    } cancelAction: {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private var columnsList: some View {
        List {
            Section {
                ForEach(viewModel.columns, id: \.self) { columnKind in
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
                    viewModel.columns.move(fromOffsets: source, toOffset: destination)
                }
            } footer: {
                Text("Distribute them according to your ticket. The one on top will be the one starting from the letf.")
            }
        }
        .navigationTitle("Ticket Columns")
    }
}

extension ColumnsDistributionView {
    enum DI {
        static func inject() -> ColumnsDistributionView {
            ColumnsDistributionView(viewModel: ColumnsDistributionViewModel())
        }
    }
}

struct ColumnsDistributionView_Previews: PreviewProvider {
    static var previews: some View {
        ColumnsDistributionView(viewModel: ColumnsDistributionViewModel())
    }
}
