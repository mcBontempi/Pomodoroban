import UIKit
import FirebaseAuth

protocol LoginViewControllerDelegate : class {
    func loginViewControllerDidSignIn(loginViewController:LoginViewController)
}


enum Mode {
    case Welcome
    case Menu
    case Login
    case Signup
}



class LoginViewController: UIViewController {
    
    var mode:Mode = .Welcome
    
    @IBOutlet weak var emailTextFieldTopSpacingToTomatoe: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var letMeInButton: UIButton!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var tomatoeTopSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tomatoeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var LOGINBUTTON: UIButton!
    @IBOutlet weak var SIGNUPBUTTON: UIButton!
    
    
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
    
    
    func signinFirebaseAccount(email:String, password: String) {
        FIRAuth.auth()!.signInWithEmail(self.email.text!, password: self.password.text!, completion: { (user, error) in
            print(error)
            if error == nil {
                SyncService.sharedInstance.setupSync()
                
                self.moveToFinished()
                
            }
            else {
                UIAlertController.quickMessage("Firebase failed to sign in", vc: self)
            }
        })
    }
    
    @IBOutlet weak var emailtoPasswordPaddingConastraint: NSLayoutConstraint!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height = UIScreen.mainScreen().bounds.height
        
        
        if height == 568 {
            self.emailTextFieldTopSpacingToTomatoe.constant = 10
            self.emailtoPasswordPaddingConastraint.constant = 10
            
        }
        
        
    }
    
    @IBAction func letMeInPressed(sender: AnyObject) {
        
        self.mode = .Menu
        
        UIView.animateWithDuration(0.3, animations: {
            self.introLabel.alpha = 0.0
            self.letMeInButton.alpha = 0.0
            
            
            }, completion: { (completed) in
                
                UIView.animateWithDuration(0.3, animations: {
                    
                    self.SIGNUPBUTTON.alpha = 1.0
                    self.LOGINBUTTON.alpha = 1.0
                    
                })
                
        })
        
        
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        
        self.mode = .Menu
        
        self.tomatoeHeightConstraint.constant = 170
        
        
        UIView.animateWithDuration(0.6, animations: {
            
            self.view.layoutIfNeeded()
            
            self.email.alpha = 0.0
            self.password.alpha = 0.0
            
            self.backButton.alpha = 0.0
            
            self.email.resignFirstResponder()
            
            
            }, completion: { (completed) in
                
                UIView.animateWithDuration(0.3, animations: {
                    
                    
                    self.SIGNUPBUTTON.alpha = 1.0
                    self.LOGINBUTTON.alpha = 1.0
                    
                    
                })
                
        })
    }
    
    
    @IBAction func loginPressed(sender: AnyObject) {
        
        
        self.mode = .Login
        
        self.tomatoeHeightConstraint.constant = 100
        
        
        UIView.animateWithDuration(0.6, animations: {
            
            self.view.layoutIfNeeded()
            
            self.SIGNUPBUTTON.alpha = 0.0
            self.LOGINBUTTON.alpha = 0.0
            
            }, completion: { (completed) in
                
                UIView.animateWithDuration(0.3, animations: {
                    
                    self.email.alpha = 1.0
                    self.password.alpha = 1.0
                    
                    self.backButton.alpha = 1.0
                    
                    self.email.becomeFirstResponder()
                    
                })
                
        })
        
    }
    
    
    
    
    
    @IBAction func signupPressed(sender: AnyObject) {
        
        
        self.mode = .Signup
        
        self.tomatoeHeightConstraint.constant = 100
        
        
        UIView.animateWithDuration(0.6, animations: {
            
            self.view.layoutIfNeeded()
            
            self.SIGNUPBUTTON.alpha = 0.0
            self.LOGINBUTTON.alpha = 0.0
            
            }, completion: { (completed) in
                
                UIView.animateWithDuration(0.3, animations: {
                    
                    self.email.alpha = 1.0
                    self.password.alpha = 1.0
                    
                    self.backButton.alpha = 1.0
                    
                    self.email.becomeFirstResponder()
                    
                })
                
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.tomatoeTopSpaceConstraint.constant = 150
        
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tomatoeTopSpaceConstraint.constant = 30
        
        UIView.animateWithDuration(1.0, animations: {
            self.view.layoutIfNeeded()
            }, completion: { (completed) in
                
                UIView.animateWithDuration(1.0, animations: {
                    self.introLabel.alpha = 1.0
                    self.letMeInButton.alpha = 1.0
                })
                
        })
    }
    
    
    func commitAction() {
        if self.mode == .Login {
            FIRAuth.auth()!.signInWithEmail(self.email.text!, password: self.password.text!, completion: { (user, error) in
                print(error)
                if error == nil {
                    SyncService.sharedInstance.setupSync()
                    
                    self.moveToFinished()
                    
                }
                else {
                    UIAlertController.quickMessage("Firebase failed to sign in", vc: self)
                }
            })
            
        }
    }
    
    
    func moveToFinished() {
        self.mode = .Menu
        
        self.tomatoeHeightConstraint.constant = 170
        
        UIView.animateWithDuration(0.6, animations: {
            
            self.view.layoutIfNeeded()
            self.email.alpha = 0.0
            self.password.alpha = 0.0
            self.backButton.alpha = 0.0
            self.email.resignFirstResponder()
            
            }, completion: { (completed) in
                UIView.animateWithDuration(0.3, animations: {
                    self.introLabel.text = "Thanks, please enjoy POMODOROBAN"
                    self.introLabel.alpha = 1.0
                })
            })
        }
    }

    extension LoginViewController : UITextFieldDelegate {
        
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            if textField == self.email {
                self.password.becomeFirstResponder()
            }
                
            else if textField == self.password {
                self.commitAction()
            }
            return true
        }
}
