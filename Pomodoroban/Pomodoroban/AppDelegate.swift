import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseDatabase
import AVFoundation
import FirebaseCrash


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let moc = CoreDataServices.sharedInstance.moc
    func appearance() {
        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue", size: 10.0)!, forKey: NSFontAttributeName)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)
    }
    
    var timerVC:TimerViewController?
    func applicationWillResignActive(application: UIApplication) {
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        
        
        //var a:Int!
        
       // a = a + 1
        
      //  FIRCrashMessage("Cause Crash button clicked")
    //    fatalError()
        
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        self.appearance()
        
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        
        Products.instance()
        
        if Ticket.count(moc) == 0 {
            Ticket.removeAllEntities(moc)
            Ticket.createAllAddTickets(moc)
            try! moc.save()
        }
        
        application.statusBarHidden = true
        
        return true
    }
    
    func setRootVC(vc:UIViewController) {
        self.window?.rootViewController = vc
    }
    
    func applicationWillTerminate(application: UIApplication) {
        CoreDataServices.sharedInstance.saveContext()
    }
    
}

