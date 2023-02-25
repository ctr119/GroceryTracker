import Foundation

class TextPage: Identifiable {
    struct Row: Identifiable, Hashable, Equatable {
        var id = UUID()
        var name: String
        var units: String
        var singlePrice: String
        var totalPrice: String
        
        static func == (lhs: Row, rhs: Row) -> Bool {
            return lhs.name == rhs.name
                && lhs.units == rhs.units
                && lhs.singlePrice == rhs.singlePrice
                && lhs.totalPrice == rhs.totalPrice
        }
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
