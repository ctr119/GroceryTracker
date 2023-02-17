import CoreData
import Foundation

enum GroceryDataSourceFactory {
    static func make() -> GroceryDataSource {
        let dbSchemeModelName = "GroceryModel"
        guard let modelUrl = Bundle().url(forResource: dbSchemeModelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("Unable to create object model")
        }
        
        let container = NSPersistentContainer(name: dbSchemeModelName, managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        return GroceryDataSourceImplementation(container: PersistentContainerImplementation(container: container))
    }
}
