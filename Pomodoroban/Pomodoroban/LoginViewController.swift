import UIKit
import FirebaseAuth

protocol LoginViewControllerDelegate : class {
    func loginViewControllerDidSignIn(loginViewController:LoginViewController)
}

class LoginViewController: UIViewController {
    
    weak var delegate:LoginViewControllerDelegate!
    
    @IBAction func user1Pressed(sender: AnyObject) {
        self.signinFirebaseAccount("user1@gmail.com", password: "DarenTaylor")
    }
    
    @IBAction func user2Pressed(sender: AnyObject) {
        self.signinFirebaseAccount("user2@gmail.com", password: "DarenTaylor")
    }
    
    @IBAction func user3Pressed(sender: AnyObject) {
        self.signinFirebaseAccount("user3@gmail.com", password: "DarenTaylor")
    }
    
    @IBAction func loginPressed(sender: AnyObject) {
        self.signinFirebaseAccount(self.email.text!, password: self.password.text!)
    }
 
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    func signinFirebaseAccount(email:String, password:String) {
        FIRAuth.auth()!.signInWithEmail(email, password: password, completion: { (user, error) in
            print(error)
            if error == nil {
                SyncService.sharedInstance.setupSync()
                self.dismissViewControllerAnimated(false, completion: nil)
                self.delegate.loginViewControllerDidSignIn(self)
            }
            else {
                UIAlertController.quickMessage("Firebase failed to sign in", vc: self)
            }
        })
    }
}
