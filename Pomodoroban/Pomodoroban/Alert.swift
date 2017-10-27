import Foundation
import CoreData

class Alert: NSManagedObject {
    
    static let entityName = "Alert"
    static let alertMessage = "message"
    
    static let attributeOrder = "message"
    
    class func count(_ moc:NSManagedObjectContext) -> Int {
        let objects = try! moc.fetch(Alert.fetchRequestAll())
        return objects.count
    }
    
    class func createInMoc(_ moc:NSManagedObjectContext) -> Alert {
        return NSEntityDescription.insertNewObject(forEntityName: Alert.entityName, into: moc) as! Alert
    }
    
    class func fetchRequestAll() -> NSFetchRequest<NSFetchRequestResult> {
        return self.fetchRequestWithPredicate(nil)
    }
    
    class func fetchRequestWithPredicate(_ predicate: NSPredicate?) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:  Alert.entityName)
        let primarySortDescriptor = NSSortDescriptor(key: Alert.attributeOrder, ascending: true)
        request.sortDescriptors = [primarySortDescriptor]
        
        request.predicate = predicate
        return request
    }

    
    
    
    class func all(_ moc:NSManagedObjectContext) -> [Alert] {
        
        return try! moc.fetch(self.fetchRequestAll()) as! [Alert]
    }
    
    class func removeAllEntities(_ moc: NSManagedObjectContext) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Alert.entityName)
        
        let objects = try! moc.fetch(request) as! [NSManagedObject]
        
        for object in objects {
            moc.delete(object)
        }
        
        try! moc.save()
        
        
    }
    
    
    class func removeAllAlerts(_ moc:NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Alert.entityName)
        
        let objects = try! moc.fetch(request) as! [Alert]
        
        for object in objects {
            
            moc.delete(object)
        }
    }
    
    
    
    
    
}
