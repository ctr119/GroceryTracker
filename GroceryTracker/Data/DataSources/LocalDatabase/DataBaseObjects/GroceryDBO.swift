import CoreData
import Foundation

struct GroceryDBO: ToNSManagedObject {
    let gid: UUID
    let name: String
    
    func toNSManagedObject(context: NSManagedObjectContext) -> NSManagedObject {
        let groceryEntity = GroceryEntity(context: context)
        groceryEntity.gid = gid
        groceryEntity.name = name
        
        return groceryEntity
    }
}

extension GroceryEntity: ToDBObject {
    func toDBObject() -> GroceryDBO? {
        guard let gid = gid, let name = name else { return nil }
        
        return GroceryDBO(gid: gid, name: name)
    }
}
