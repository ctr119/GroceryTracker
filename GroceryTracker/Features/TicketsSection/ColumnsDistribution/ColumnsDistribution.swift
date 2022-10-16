import Foundation

struct ColumnsDistribution {
    static let defaultDistribution: ColumnsDistribution = .init(namePosition: 0,
                                                                unitsPosition: 1,
                                                                singlePricePosition: 2,
                                                                totalPricePosition: 3)
    
    struct Column: Identifiable {
        var id: String {
            name
        }
        let name: String
        let position: Int
    }
    
    let nameColumn: Column
    let unitsColumn: Column
    let singlePriceColumn: Column
    let totalPriceColumn: Column
    
    init(namePosition: Int,
         unitsPosition: Int,
         singlePricePosition: Int,
         totalPricePosition: Int) {
        
        self.nameColumn = Column(name: "Name", position: namePosition)
        self.unitsColumn = Column(name: "Units", position: unitsPosition)
        self.singlePriceColumn = Column(name: "Price", position: singlePricePosition)
        self.totalPriceColumn = Column(name: "Total", position: totalPricePosition)
    }
}
