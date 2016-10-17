import UIKit
import LSRepeater
import Firebase

class SyncService {
    
    var repeater:LSRepeater!
    
    static let sharedInstance = SyncService()
    
    func start() {
        self.repeater = LSRepeater.repeater(10, execute: {
            self.sync()
        })
    }
    
    let storage = FIRStorage.storage()
    
    let ref = FIRDatabase.database().reference()
    
   //
    func sync() {
     
        
        
        
        let storageRef = self.storage.reference()
        
        let screenshotRef = storageRef.child("screenshot.jpg")
        
    }
}

/*
 func upload() {
 let image =  self.view.image()
 
 if let data = UIImageJPEGRepresentation(image!,3) {
 
 let storageRef = storage.reference()
 
 let screenshotRef = storageRef.child("screenshot.jpg")
 
 let uploadTask = screenshotRef.putData(data, metadata: nil) { metadata, error in
 if let error = error {
 UIAlertController.quickMessage(error.description, vc:self)
 } else {
 print("uploaded")
 let downloadURL = metadata!.downloadURL()
 }
 }
 }
 }
 */
