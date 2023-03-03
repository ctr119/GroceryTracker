import CoreData
import Foundation

struct PurchaseDBO: ToNSManagedObject {
    let tid: UUID
    let gid: UUID
    let fid: UUID
    let quantity: Int
    
    func toNSManagedObject(context: NSManagedObjectContext) -> NSManagedObject {
        let purchaseEntity = PurchaseEntity(context: context)
        purchaseEntity.tid = tid
        purchaseEntity.gid = gid
        purchaseEntity.fid = fid
        purchaseEntity.quantity = Int16(quantity)
        
        return purchaseEntity
    }
}

extension PurchaseEntity: ToDBObject {
    func toDBObject() -> PurchaseDBO? {
        guard let tid = tid, let gid = gid, let fid = fid else { return nil }
        
        return PurchaseDBO(tid: tid, gid: gid, fid: fid, quantity: Int(quantity))
    }
}
