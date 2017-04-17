import UIKit
import Firebase
import FirebaseDatabase
import CoreData
import FirebaseAuth

class SyncService : NSObject {
    
    let moc = CoreDataServices.sharedInstance.moc
    
    static let sharedInstance = SyncService()
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let tempFetchedResultsController =
            
            NSFetchedResultsController(fetchRequest: Ticket.fetchRequestAllIncludingDeleted(), managedObjectContext: self.moc, sectionNameKeyPath: "section", cacheName: nil)
        
        tempFetchedResultsController.delegate = self
        return tempFetchedResultsController
    }()
    
    
    let ref = FIRDatabase.database().reference()
    
    func isSynced() -> Bool {
        
        if let auth = FIRAuth.auth() {
            if let currentUser = auth.currentUser {
                
                let uid = currentUser.uid
                
                
                
            }
            
        }
        
        return true
    }
    
    
    func removeAllForSignOut() {
        
        
        let uid = FIRAuth.auth()!.currentUser?.uid
        let ticketRef = self.ref.child(uid!)
        ticketRef.removeAllObservers()
        
        Ticket.removeAllEntities(self.moc)
        Ticket.createAllAddTickets(self.moc)
        
        self.fetchedResultsController.delegate = nil
        
        try! self.moc.save()
        
    }
    
    func syncExisting() {
        let tickets = Ticket.allWithoutControl(self.moc)
        
        for ticket in tickets {
            let ref = FIRDatabase.database().reference()
            
            let uid = FIRAuth.auth()!.currentUser?.uid
            
            let ticketRef = ref.child(uid!).child(ticket.identifier!)
            ticketRef.setValue(["name" : ticket.name!,"row" : "\(ticket.row)","section" : "\(ticket.section)", "identifier" : ticket.identifier!, "colorIndex" : "\(ticket.colorIndex)", "pomodoroEstimate" : "\(ticket.pomodoroEstimate)", "removed" : "\(ticket.removed)", "desc" : ticket.desc])
        }
    }
    
    var connected = false
    
    func setupOfflineWatcher() {
      
        FIRDatabase.database().reference(withPath: ".info/connected").observe(.value, with: { snapshot in
            self.connected = snapshot.value as! Bool
        })
    }
    
    func setupSync() {
        
     self.setupOfflineWatcher()
        
        
        try! self.fetchedResultsController.performFetch()
        
        if let auth = FIRAuth.auth() {
            if let currentUser = auth.currentUser {
                
                let uid = currentUser.uid
                let ticketRef = self.ref.child(uid)
                
                
                
                
                
                
                ticketRef.observe(.value, with: { (snapshot) in
                    
                    for ticket in snapshot.children {
                        
                        let snapshot = ticket as! FIRDataSnapshot
                        
                        let dict = snapshot.value as! NSDictionary
                        
                        let identifier = dict.object(forKey: "identifier") as! String
                        
                        if let createOrUpdateTicket = Ticket.createOrUpdate(self.moc, identifier: identifier) {
                            
                            let name = dict.object(forKey: "name") as! String
                            
                            let section = dict.object(forKey: "section") as! String
                            
                            let row = dict.object(forKey: "row") as! String
                            
                            let colorIndex = dict.object(forKey: "colorIndex") as! String
                            
                            let pomodoroEstimate = dict.object(forKey: "pomodoroEstimate") as! String
                            
                            let removed = dict.object(forKey: "removed") as! String
                            
                            let removedBool = removed == "true" ? true : false
                            
                            let desc = dict.object(forKey: "desc") as! String
                            
                            
                            print (section)
                            print (createOrUpdateTicket.section)
                            
                            
                            if name != createOrUpdateTicket.name || createOrUpdateTicket.section != Int32(section)! || createOrUpdateTicket.row != Int32(row)! || createOrUpdateTicket.colorIndex != Int32(colorIndex)! || createOrUpdateTicket.pomodoroEstimate != Int32(pomodoroEstimate)! || createOrUpdateTicket.removed != removedBool || desc != createOrUpdateTicket.desc {
                                
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
    }
}

extension SyncService : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let ticket = anObject as? Ticket {
            
            
            let ref = FIRDatabase.database().reference()
            
    
   
            
            
            
            if let auth = FIRAuth.auth() {
                if let currentUser = auth.currentUser {
                    
                    let uid = currentUser.uid
                    
                    
                    let ticketRef = ref.child(uid).child(ticket.identifier!)
                    ticketRef.setValue(["name" : ticket.name!,"row" : "\(ticket.row)","section" : "\(ticket.section)", "identifier" : ticket.identifier!, "colorIndex" : "\(ticket.colorIndex)", "pomodoroEstimate" : "\(ticket.pomodoroEstimate)", "removed" : "\(ticket.removed)", "desc" : ticket.desc])
                }
            }
        }
    }
    
}
