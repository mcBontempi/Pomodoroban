import Foundation
import CoreData

class Runtime: NSManagedObject {
    
    static let entityName = "Runtime"
    static let attributeOrder = "order"
    static let attributeLength = "length"
    static let attributeType = "type"
    static let attributeTicket = "ticket"
    
    class func count(moc:NSManagedObjectContext) -> Int {
        let objects = try! moc.executeFetchRequest(Runtime.fetchRequestAll())
        return objects.count
    }
    
    class func createInMoc(moc:NSManagedObjectContext) -> Runtime {
        return NSEntityDescription.insertNewObjectForEntityForName(Runtime.entityName, inManagedObjectContext: moc) as! Runtime
    }
    
    class func fetchRequestAll() -> NSFetchRequest {
        return self.fetchRequestWithPredicate(nil)
    }
    
    class func fetchRequestWithPredicate(predicate: NSPredicate?) -> NSFetchRequest {
        let request = NSFetchRequest(entityName: Runtime.entityName)
        let primarySortDescriptor = NSSortDescriptor(key: Runtime.attributeOrder, ascending: true)
        request.sortDescriptors = [primarySortDescriptor]
        
        request.predicate = predicate
        return request
    }
    
    
    class func createForToday(moc:NSManagedObjectContext, taskLength:Int32, shortLength:Int32, longLength:Int32) {
        
        let tickets = Ticket.allForToday(moc)
        
        for ticket in tickets {
            
            for i in 0 ... ticket.pomodoroEstimate {
                
                
                let runtime = Runtime.createInMoc(moc)
                
               // runtime.length
                
                
                
            }
            
            
        }
        
        
    }

    class func all(moc:NSManagedObjectContext) -> [Runtime] {
        
        return try! moc.executeFetchRequest(self.fetchRequestAll()) as! [Runtime]
    }
    
    class func removeAllEntities(moc: NSManagedObjectContext) {
        
        let request = NSFetchRequest(entityName: Runtime.entityName)
        
        let objects = try! moc.executeFetchRequest(request) as! [NSManagedObject]
        
        for object in objects {
            moc.deleteObject(object)
        }
        
        try! moc.save()
        
        
    }
    
    
    class func removeAllRuntimes(moc:NSManagedObjectContext) {
        let request = NSFetchRequest(entityName: Runtime.entityName)
        
        let objects = try! moc.executeFetchRequest(request) as! [Runtime]
        
        for object in objects {
            
                moc.deleteObject(object)
        }
    }
    
    
    class func printAll(moc:NSManagedObjectContext) {
        let request = NSFetchRequest(entityName: Runtime.entityName)
        
        let objects = try! moc.executeFetchRequest(request) as! [Runtime]
        
        for object in objects {
            
            print(object)
        }
        
    }

    
    }
