import Foundation

struct ColumnsDistribution {
    static let defaultDistribution: ColumnsDistribution = .init(namePosition: 0, unitsPosition: 1, singlePricePosition: 2, totalPricePosition: 3)
    
    let namePosition: Int
    let unitsPosition: Int
    let singlePricePosition: Int
    let totalPricePosition: Int
}
