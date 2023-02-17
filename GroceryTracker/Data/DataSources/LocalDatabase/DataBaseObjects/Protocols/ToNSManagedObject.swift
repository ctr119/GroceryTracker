import CoreData

protocol ToNSManagedObject {
    func toNSManagedObject(context: NSManagedObjectContext) -> NSManagedObject
}
