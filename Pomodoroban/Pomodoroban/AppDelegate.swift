import UIKit
import CoreData
import Fabric
import Crashlytics
import UserNotifications
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        SyncService.sharedInstance.start()
        
        FIRApp.configure()
        
        
        
        
        
        application.statusBarHidden = true
        
        
        
        UNUserNotificationCenter.currentNotificationCenter().requestAuthorizationWithOptions([.Alert,.Sound]) { (bool:Bool, error:NSError?) in
            
        }
        
        
        Fabric.with([Crashlytics.self])
        
        let moc = CoreDataServices.sharedInstance.moc
        
        
        if Ticket.count(moc) == 0 {
            Ticket.removeAllEntities(moc)
            Ticket.createAllAddTickets(moc)
            try! moc.save()
        }
        
        
  //      self.createFirebaseAccount("mcbontempi@gmail.com", password: "Debb123x")
        
        self.signinFirebaseAccount("mcbontempi@gmail.com", password: "Debb123x")
        
        
        return true
    }
    
    func createFirebaseAccount(email:String, password:String) {
        
        FIRAuth.auth()!.createUserWithEmail(email,password:password) { user, error in
            if error == nil {
                
                UIAlertController.quickMessage("Firebase account created", vc: self.window!.rootViewController!)
                
                FIRAuth.auth()!.signInWithEmail(email, password: password, completion: { (user, error) in
                    
                    UIAlertController.quickMessage("Firebase signed in", vc: self.window!.rootViewController!)
                })
            }
            else {
                UIAlertController.quickMessage("Error creating account", vc: self.window!.rootViewController!)
                
            }
        }
    }
    
    func signinFirebaseAccount(email:String, password:String) {
        
        FIRAuth.auth()!.signInWithEmail(email, password: password, completion: { (user, error) in
            
            UIAlertController.quickMessage("Firebase signed in", vc: self.window!.rootViewController!)
        })
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        CoreDataServices.sharedInstance.saveContext()
    }
    
}

