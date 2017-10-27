import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseDatabase
import AVFoundation
import FirebaseCrash
import UserNotifications

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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.appearance()
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        application.isStatusBarHidden = true
        
        return true
    }
    
    func gotoLogin() {
        let root = self.window?.rootViewController as! RootViewController
        root.gotoLogin()
    }
    
    func gotoFeed() {
        let root = self.window?.rootViewController as! RootViewController
        root.gotoFeed()
        
        let when = DispatchTime.now() + 2
        
        DispatchQueue.main.asyncAfter(deadline: when) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { (granted:Bool, error:Error?) in
            
        }
        }
    }
    
    func setRootVC(_ vc:UIViewController) {
        self.window?.rootViewController = vc
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataServices.sharedInstance.saveContext()
    }
    
}

