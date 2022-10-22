import Foundation
import SwiftUI

class ColumnsDistributionViewModel: ObservableObject {
    @Published var columns: [ColumnsDistribution.Column.Kind] = [
        .name, .units, .singlePrice, .totalPrice
    ]
    
    func getDistribution() -> ColumnsDistribution? {
        var dictionary: [ColumnsDistribution.Column.Kind : Int] = [:]

        for (index, colKind) in columns.enumerated() {
            dictionary[colKind] = index
        }

        guard let namePosition = dictionary[.name],
              let unitsPosition = dictionary[.units],
              let singlePricePosition = dictionary[.singlePrice],
              let totalPricePosition = dictionary[.totalPrice] else { return nil }
        
        return ColumnsDistribution(namePosition: namePosition,
                                   unitsPosition: unitsPosition,
                                   singlePricePosition: singlePricePosition,
                                   totalPricePosition: totalPricePosition)
    }
}
