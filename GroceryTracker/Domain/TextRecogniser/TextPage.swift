import Foundation

class TextPage: Identifiable {
    struct Row {
        var name: String
        var units: String
        var singlePrice: String
        var totalPrice: String
    }
    
    let id = UUID()
    
    var finalRows: [Row] = []
    
    func addRow(_ row: [String], distribution: ColumnsDistribution) {
        let newRow = Row(name: row[distribution.namePosition],
                         units: row[distribution.unitsPosition],
                         singlePrice: row[distribution.singlePricePosition],
                         totalPrice: row[distribution.totalPricePosition])
        finalRows.append(newRow)
    }
    
    // OLD
    
    private var rows: [[String]] = []
    
    func getRows() -> [[String]] {
        return rows
    }
        
    func addRow(_ row: [String]) {
        rows.append(row)
    }
    
    func row(at index: Int) -> [String] {
        rows[index]
    }
    
    func set(row: [String], at index: Int) {
        rows[index] = row
    }
}

// NON-USED...
//extension String {
//    func isNumber() -> Bool {
//        Double(self) != nil
//    }
//}
//// NON-USED...
//extension Double {
//    func hasDecimals() -> Bool {
//        self.truncatingRemainder(dividingBy: 1) != 0
//    }
//}
