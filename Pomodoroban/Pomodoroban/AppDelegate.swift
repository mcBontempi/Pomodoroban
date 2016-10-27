import UIKit
import CoreData
import Fabric
import Crashlytics
import Firebase
import FirebaseAuth
import FirebaseDatabase

import Speech

import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let moc = CoreDataServices.sharedInstance.moc
    
    func testSpeech() {
          let utterance = AVSpeechUtterance(string: "")
         let synth = AVSpeechSynthesizer()
        ///  synth.speakUtterance(utterance)
        //  synth.outputChannels?.append(<#T##newElement: Element##Element#>)
    
        
        
        NSSpeechSynthesizer 
    
    synth.sta
    }
    
    func appearance() {
        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!, forKey: NSFontAttributeName)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        self.appearance()
        
        
        
        
        
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        
          let products =  Products.instance()
             print(products.productsArray)
        
        if Ticket.count(moc) == 0 {
            Ticket.removeAllEntities(moc)
            Ticket.createAllAddTickets(moc)
            try! moc.save()
        }
        
        application.statusBarHidden = true
        
        Fabric.with([Crashlytics.self])
        
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

