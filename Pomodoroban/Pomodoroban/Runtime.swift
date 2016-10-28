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

    
    class func createForToday(moc:NSManagedObjectContext, pomodoroLength:Double, shortBreakLength:Double, longBreakLength:Double, shortBreakCount: Int) {
        
        let tickets = Ticket.allForToday(moc)
        
        var index:Int32 = 0
        var shortBreakIndex = 0
        
        for ticket in tickets {
            
            for i in 0 ..< ticket.pomodoroEstimate {
                
                // add the task
                let runtime = Runtime.createInMoc(moc)
                runtime.length = Int32(pomodoroLength)
                runtime.ticket = ticket
                runtime.type = 0
                runtime.order = index
                runtime.part = i + 1
                
                index = index + 1
                
                
                if ticket == tickets.last && i == ticket.pomodoroEstimate - 1 {
                    // end of day here
                }
                else {
                    // add the break
                    
                    let breakRuntime = Runtime.createInMoc(moc)
                    breakRuntime.order = index
                    
                    if shortBreakCount == shortBreakIndex {
                        // add long break
                        shortBreakIndex = 0
                        
                        breakRuntime.length = Int32(longBreakLength)
                        breakRuntime.type = 2
                        
                        
                        
                    }
                    else {
                        // add the short break
                        breakRuntime.length = Int32(shortBreakLength)
                        breakRuntime.type = 1
                  
                        shortBreakIndex = shortBreakIndex + 1
                        
                    }
                    
                    index = index + 1
                }
                
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
    
    

    
    
}
