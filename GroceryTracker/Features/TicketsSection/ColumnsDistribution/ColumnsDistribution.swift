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
        
    init(namePosition: Int,
         unitsPosition: Int,
         singlePricePosition: Int,
         totalPricePosition: Int) {
        
        self.nameColumn = .init(name: "Name", position: namePosition)
        self.unitsColumn = .init(name: "Units", position: unitsPosition)
        self.singlePriceColumn = .init(name: "Price", position: singlePricePosition)
        self.totalPriceColumn = .init(name: "Total", position: totalPricePosition)
    }
    
    let nameColumn: Column
    let unitsColumn: Column
    let singlePriceColumn: Column
    let totalPriceColumn: Column
}
