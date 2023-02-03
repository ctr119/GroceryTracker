import Foundation
import SwiftUI

class ColumnsDistributionViewModel: ObservableObject {
    @Published var shouldOpenScanner = false
    private(set) var distribution: ColumnsDistribution? = nil
    
    var columns: [ColumnsDistribution.Column.Kind] = [
        .name, .units, .singlePrice, .totalPrice
    ]
    
    func saveCurrentDistribution() {
        var dictionary: [ColumnsDistribution.Column.Kind : Int] = [:]

        for (index, colKind) in columns.enumerated() {
            dictionary[colKind] = index
        }

        guard let namePosition = dictionary[.name],
              let unitsPosition = dictionary[.units],
              let singlePricePosition = dictionary[.singlePrice],
              let totalPricePosition = dictionary[.totalPrice] else { return }
        
        distribution = ColumnsDistribution(namePosition: namePosition,
                                           unitsPosition: unitsPosition,
                                           singlePricePosition: singlePricePosition,
                                           totalPricePosition: totalPricePosition)
        
        shouldOpenScanner = true
    }
}
