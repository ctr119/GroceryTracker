import CoreData
import Foundation

struct PriceDBO: ToNSManagedObject {
    let fid: UUID
    let gid: UUID
    let amount: Double
    let unit: String
    
    func toNSManagedObject(context: NSManagedObjectContext) -> NSManagedObject {
        let saleEntity = PriceEntity(context: context)
        saleEntity.fid = fid
        saleEntity.gid = gid
        saleEntity.amount = amount
        saleEntity.unit = unit
        
        return saleEntity
    }
}

extension PriceEntity: ToDBObject {
    func toDBObject() -> PriceDBO? {
        guard let fid = fid,
                let gid = gid,
                let unit = unit else { return nil }
        
        return PriceDBO(fid: fid,
                        gid: gid,
                        amount: amount,
                        unit: unit)
    }
}
