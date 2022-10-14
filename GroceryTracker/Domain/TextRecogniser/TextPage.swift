import Foundation

class TextPage: Identifiable {
    struct Row: Identifiable {
        var id = UUID()
        var name: String
        var units: String
        var singlePrice: String
        var totalPrice: String
    }
    
    let id = UUID()
    
    private(set) var rows: [Row] = []
    
    func addRow(_ row: [String], distribution: ColumnsDistribution) {
        let newRow = Row(name: row[distribution.nameColumn.position],
                         units: row[distribution.unitsColumn.position],
                         singlePrice: row[distribution.singlePriceColumn.position],
                         totalPrice: row[distribution.totalPriceColumn.position])
        rows.append(newRow)
    }
}
