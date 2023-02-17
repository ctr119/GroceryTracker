import CoreData
import Foundation

struct TicketDBO: ToNSManagedObject {
    let tid: UUID
    let date: Date
    
    func toNSManagedObject(context: NSManagedObjectContext) -> NSManagedObject {
        let ticketEntity = TicketEntity(context: context)
        ticketEntity.tid = tid
        ticketEntity.date = date
        
        return ticketEntity
    }
}

extension TicketEntity: ToDBObject {
    func toDBObject() -> TicketDBO? {
        guard let tid = tid, let date = date else { return nil }
        
        return TicketDBO(tid: tid, date: date)
    }
}
