import UIKit
import CoreData
import Fabric
import Crashlytics
import UserNotifications
import Firebase
import FirebaseAuth
import FirebaseDatabase

import Speech

import AVFoundation



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  //  Products.instance()
  
    var window: UIWindow?
    
    let moc = CoreDataServices.sharedInstance.moc
    
    
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
     
        
        
        
        
      //  let utterance = AVSpeechUtterance(string: "")
        
      //  let synth = AVSpeechSynthesizer()
        
       // synth.speakUtterance(utterance)
        
        
      //  synth.outputChannels
        
        
        
        
        if Ticket.count(moc) == 0 {
            Ticket.removeAllEntities(moc)
            Ticket.createAllAddTickets(moc)
            try! moc.save()
        }
        
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
       
        
        application.statusBarHidden = true
        UNUserNotificationCenter.currentNotificationCenter().requestAuthorizationWithOptions([.Alert,.Sound]) { (bool:Bool, error:NSError?) in
        }
        
        Fabric.with([Crashlytics.self])
        
        
  //      self.createFirebaseAccount("user1@gmail.com", password: "DarenTaylor")
    //    self.createFirebaseAccount("user2@gmail.com", password: "DarenTaylor")
      //  self.createFirebaseAccount("user3@gmail.com", password: "DarenTaylor")
        
        
        return true
    }
    
    func setRootVC(vc:UIViewController) {
        
        self.window?.rootViewController = vc
        
    }
    
    
    func createFirebaseAccount(email:String, password:String) {
        
        FIRAuth.auth()!.createUserWithEmail(email,password:password) { user, error in
            if error == nil {
                
                   UIAlertController.quickMessage("Firebase account created", vc: self.window!.rootViewController!)
                
             //   FIRAuth.auth()!.signInWithEmail(email, password: password, completion: { (user, error) in
             //
             //            UIAlertController.quickMessage("Firebase signed in", vc: self.window!.rootViewController!)
             //   })
            }
            else {
                   UIAlertController.quickMessage("Error creating account", vc: self.window!.rootViewController!)
                
            }
        }
    }
    
    
    func applicationWillTerminate(application: UIApplication) {
        CoreDataServices.sharedInstance.saveContext()
    }
    
}

