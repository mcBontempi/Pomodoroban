import UIKit
import CoreData
import Fabric
import Crashlytics
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        FIRApp.configure()
        
        application.statusBarHidden = true
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        gai.dispatchInterval = 1
        
        
        UNUserNotificationCenter.currentNotificationCenter().requestAuthorizationWithOptions([.Alert,.Sound]) { (bool:Bool, error:NSError?) in
            
        }
    
    
    Fabric.with([Crashlytics.self])
    
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

