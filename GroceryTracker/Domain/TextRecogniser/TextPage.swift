import Foundation

class TextPage: Identifiable {
    let id = UUID()
    
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
