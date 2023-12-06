import CoreData

protocol PersistentContainer {
    func fetch<E, R>(request: NSFetchRequest<E>) async throws -> [R] where E: NSManagedObject, E: ToDBObject, R == E.ObjectType
    func saveInContext<T>(dbObjects: [T]) async throws where T: ToNSManagedObject
    func runBlock(_ block: @escaping (NSManagedObjectContext) -> Void) async throws
}

class PersistentContainerImplementation: PersistentContainer {
    // DOC: Difference between 'container.viewContext.perform' and 'container.performBackgroundTask'
    // DOC: https://stackoverflow.com/questions/53633366/coredata-whats-the-difference-between-performbackgroundtask-and-newbackgroundc
    
    private var container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func fetch<E, R>(request: NSFetchRequest<E>) async throws -> [R] where E: NSManagedObject, E: ToDBObject, R == E.ObjectType {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[R], Error>) in
            self.container.viewContext.perform {
                do {
                    let result = try self.container.viewContext.fetch(request).compactMap { $0.toDBObject() }
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func saveInContext<T>(dbObjects: [T]) async throws where T: ToNSManagedObject {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            self.container.viewContext.perform {
                do {
                    for dbObject in dbObjects {
                        _ = dbObject.toNSManagedObject(context: self.container.viewContext)
                    }
                    try self.container.viewContext.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func runBlock(_ block: @escaping (NSManagedObjectContext) -> Void) async throws {
        try await container.viewContext.perform {
            block(self.container.viewContext)
            try self.container.viewContext.save()
        }
    }
}
