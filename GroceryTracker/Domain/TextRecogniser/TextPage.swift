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
    
    func add(row: Row) {
        rows.append(row)
    }
    
    func addRow(_ row: [String], distribution: ColumnsDistribution) {
        let newRow = Row(name: extractValue(from: row, position: distribution.nameColumn.position) ?? "",
                         units: extractValue(from: row, position: distribution.unitsColumn.position) ?? "",
                         singlePrice: extractValue(from: row, position: distribution.singlePriceColumn.position) ?? "",
                         totalPrice: extractValue(from: row, position: distribution.totalPriceColumn.position) ?? "")
        rows.append(newRow)
    }
    
    private func extractValue(from row: [String], position: Int) -> String? {
        guard position < row.count else { return nil }
        
        return row[position]
    }
}
