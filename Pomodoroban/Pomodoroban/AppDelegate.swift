import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseDatabase
import AVFoundation
import FirebaseCrash
import Emmlytics
    


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let moc = CoreDataServices.sharedInstance.moc
    func appearance() {
   //     let attr = NSDictionary(object: UIFont(name: "HelveticaNeue", size: 10.0)!, forKey: NSFontAttributeName as NSCopying)
   //     UISegmentedControl.appearance().setTitleTextAttributes(attr as? [AnyHashable: Any] , for: UIControlState())
    }
    
    var timerVC:TimerViewController?
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func setupEmmylitics() {
        UserDefaults.standard.set("mcbontempi@gmail.com", forKey: "emmlyticsUserID")
        UserDefaults.standard.set("https://emmlytics.mynetgear.com:8443/", forKey: "emmlyticsURL")
        UserDefaults.standard.set("Pomodoroban", forKey: "emmlyticsAppId")
        
        //typical event below!
        Emmlytics().sendAnalytics(event: "appload")
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        self.setupEmmylitics()
        
        
        
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.appearance()
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        if Ticket.count(moc) == 0 {
            Ticket.removeAllEntities(moc)
            Ticket.createAllAddTickets(moc)
            try! moc.save()
        }
        
        application.isStatusBarHidden = true
        
        return true
    }
    
    func setRootVC(_ vc:UIViewController) {
        self.window?.rootViewController = vc
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataServices.sharedInstance.saveContext()
    }
    
}

