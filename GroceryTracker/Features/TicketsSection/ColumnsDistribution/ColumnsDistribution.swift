import Foundation

struct ColumnsDistribution: Identifiable {
    static let defaultDistribution: ColumnsDistribution = .init(namePosition: 0,
                                                                unitsPosition: 1,
                                                                singlePricePosition: 2,
                                                                totalPricePosition: 3)
    
    struct Column: Identifiable {
        enum Kind: String {
            case name = "Name"
            case units = "Units"
            case singlePrice = "Price"
            case totalPrice = "Total"
        }
        
        var id: String {
            kind.rawValue
        }
        let kind: Kind
        let position: Int
    }
    
    let id = UUID()
    
    let nameColumn: Column
    let unitsColumn: Column
    let singlePriceColumn: Column
    let totalPriceColumn: Column
    
    init(namePosition: Int,
         unitsPosition: Int,
         singlePricePosition: Int,
         totalPricePosition: Int) {
        
        self.nameColumn = Column(kind: .name, position: namePosition)
        self.unitsColumn = Column(kind: .units, position: unitsPosition)
        self.singlePriceColumn = Column(kind: .singlePrice, position: singlePricePosition)
        self.totalPriceColumn = Column(kind: .totalPrice, position: totalPricePosition)
    }
}
