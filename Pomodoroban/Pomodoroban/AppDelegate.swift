import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseDatabase
import AVFoundation
import FirebaseCrash
import UserNotifications
import Appsee

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    @IBAction func playPressed(_ sender: Any) {
    }
    
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
     
        self.createAlerts()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        self.appearance()
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        application.isStatusBarHidden = true
        
        Appsee.start("7474218a1a5e4dce93495b2075d83b4c")
        
        return true
    }
    
    func createAlerts() {
        let content = UNMutableNotificationContent()
        content.title = "Calchua"
        content.body = "It's about that time of day that you need to think about settign your tasks for tomorrow"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "dave"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 11
        dateComponents.minute = 26
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest.init(identifier: "Daily Remonder", content: content, trigger: trigger)
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    func gotoTimer() -> TimerViewController {
        let root = self.window?.rootViewController as! RootViewController
        return root.gotoTimer()
    }
    
    func hideTimer() {
        let root = self.window?.rootViewController as! RootViewController
        return root.hideTimer()
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

