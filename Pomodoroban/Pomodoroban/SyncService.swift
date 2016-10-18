import UIKit
import LSRepeater
import Firebase
import FirebaseDatabase
import CoreData

class SyncService : NSObject {
    
    var repeater:LSRepeater!
    
    let moc = CoreDataServices.sharedInstance.moc
    
    static let sharedInstance = SyncService()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let tempFetchedResultsController = NSFetchedResultsController( fetchRequest: Ticket.fetchRequestAllIncludingDeleted(), managedObjectContext: self.moc, sectionNameKeyPath: "section", cacheName: nil)
        tempFetchedResultsController.delegate = self
        return tempFetchedResultsController
    }()
    
    
    let ref = FIRDatabase.database().reference()
    
    func removeAllForSignOut() {
        
        
        let uid = FIRAuth.auth()!.currentUser?.uid
        let ticketRef = self.ref.child(uid!)
        ticketRef.removeAllObservers()
       
        Ticket.removeAllEntities(self.moc)
        Ticket.createAllAddTickets(self.moc)
        
        self.fetchedResultsController.delegate = nil
        
        try! self.moc.save()
        
        self.fetchedResultsController.delegate = self
    }
    
    
    func setupSync() {
        
        try! self.fetchedResultsController.performFetch()
        
        let uid = FIRAuth.auth()!.currentUser?.uid
                let ticketRef = self.ref.child(uid!)
        
        ticketRef.observeEventType(.Value, withBlock: { (snapshot) in
            
            for ticket in snapshot.children {
                
                let snapshot = ticket as! FIRDataSnapshot
                
                let dict = snapshot.value as! NSDictionary
                
                let identifier = dict.objectForKey("identifier") as! String
                
                if let createOrUpdateTicket = Ticket.createOrUpdate(self.moc, identifier: identifier) {
                    
                    let name = dict.objectForKey("name") as! String
                    
                    let section = dict.objectForKey("section") as! String
                    
                    let row = dict.objectForKey("row") as! String
                    
                    let colorIndex = dict.objectForKey("colorIndex") as! String
                    
                    let pomodoroEstimate = dict.objectForKey("pomodoroEstimate") as! String
                    
                    let removed = dict.objectForKey("removed") as! String
                    
                    let removedBool = removed == "true" ? true : false
                    
                    let desc = dict.objectForKey("desc") as! String
                    
                    if name != createOrUpdateTicket.name || createOrUpdateTicket.section != Int32(section)! || createOrUpdateTicket.row != Int32(row)! || createOrUpdateTicket.colorIndex != Int32(colorIndex)! || createOrUpdateTicket.pomodoroEstimate != Int32(pomodoroEstimate)! || createOrUpdateTicket.removed != removedBool || desc != createOrUpdateTicket.desc {
                        
                        print(name)
                        print(createOrUpdateTicket.name)
                        
                        createOrUpdateTicket.name = name
                        
                        createOrUpdateTicket.row = Int32(row)!
                        
                        createOrUpdateTicket.section = Int32(section)!
                        
                        createOrUpdateTicket.identifier = identifier
                        
                        createOrUpdateTicket.colorIndex = Int32(colorIndex)!
                        
                        createOrUpdateTicket.pomodoroEstimate = Int32(pomodoroEstimate)!
                        
                        createOrUpdateTicket.removed = removedBool
                        
                        createOrUpdateTicket.desc = desc
                        
                        self.fetchedResultsController.delegate = nil
                        
                        try! self.moc.save()
                        
                        self.fetchedResultsController.delegate = self
                    }
                }
            }
        })
    }
}

extension SyncService : NSFetchedResultsControllerDelegate {
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        print(type)
        
        if let ticket = anObject as? Ticket {
            
            
                let ref = FIRDatabase.database().reference()
            
                let uid = FIRAuth.auth()!.currentUser?.uid
            
                let ticketRef = ref.child(uid!).child(ticket.identifier!)
            ticketRef.setValue(["name" : ticket.name!,"row" : "\(ticket.row)","section" : "\(ticket.section)", "identifier" : ticket.identifier!, "colorIndex" : "\(ticket.colorIndex)", "pomodoroEstimate" : "\(ticket.pomodoroEstimate)", "removed" : "\(ticket.removed)", "desc" : ticket.desc])
        }
    }
    
}
