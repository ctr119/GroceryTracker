import CoreData
import Foundation

struct SaleDBO: ToNSManagedObject {
    let fid: UUID
    let gid: UUID
    let price: Double
    let unit: String
    
    func toNSManagedObject(context: NSManagedObjectContext) -> NSManagedObject {
        let saleEntity = SaleEntity(context: context)
        saleEntity.fid = fid
        saleEntity.gid = gid
        saleEntity.price = price
        saleEntity.unit = unit
        
        return saleEntity
    }
}

extension SaleEntity: ToDBObject {
    func toDBObject() -> SaleDBO? {
        guard let fid = fid,
                let gid = gid,
                let unit = unit else { return nil }
        
        return SaleDBO(fid: fid,
                       gid: gid,
                       price: price,
                       unit: unit)
    }
}
