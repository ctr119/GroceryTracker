import Foundation

protocol ToDBObject {
    associatedtype ObjectType
    func toDBObject() -> ObjectType
}
