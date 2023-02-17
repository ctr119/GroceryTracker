import Foundation
import CoreData

struct FoodDBO: ToNSManagedObject {
    let fid: UUID
    let name: String
    
    func toNSManagedObject(context: NSManagedObjectContext) -> NSManagedObject {
        let foodEntity = FoodEntity(context: context)
        foodEntity.fid = fid
        foodEntity.name = name
        
        return foodEntity
    }
}

extension FoodEntity: ToDBObject {
    func toDBObject() -> FoodDBO? {
        guard let fid = fid,
              let name = name else { return nil }
        
        return FoodDBO(fid: fid,
                       name: name)
    }
}
