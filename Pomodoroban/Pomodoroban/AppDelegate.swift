import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let moc = CoreDataServices.sharedInstance.moc
        
      
        if Ticket.count(moc) == 0 {
            Ticket.removeAllEntities(moc)
            Ticket.createAllAddTickets(moc)
            try! moc.save()
        }
        
        return true
    }
    
    func applicationWillTerminate(application: UIApplication) {
        CoreDataServices.sharedInstance.saveContext()
    }
    
}

