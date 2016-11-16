import UIKit
import Firebase
import FirebaseAuth
import MBProgressHUD
import EasyTipView

protocol LoginViewControllerDelegate : class {
    func loginViewControllerDidSignIn(loginViewController:LoginViewController)
}

enum Mode {
    case Welcome
    case Menu
    case Login
    case Signup
    case SignupOnly
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
    @IBOutlet weak var JUSTLETMEINBUTTON: UIButton!
    
    
    weak var delegate:LoginViewControllerDelegate!
    
    func signinFirebaseAccount(email:String, password: String) {
        FIRAuth.auth()!.signInWithEmail(email, password: password, completion: { (user, error) in
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
    
    
    func cornerView(view:UIView,radius:CGFloat) {
        view.layer.cornerRadius = radius
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in [self.letMeInButton, self.SIGNUPBUTTON,self.LOGINBUTTON, self.JUSTLETMEINBUTTON] {
            self.cornerView(view,radius:5)
        }
        
        
        
    }
    @IBAction func justLetMeInPressed(sender: AnyObject) {
        
        self.moveToFinished()
        
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
                    self.JUSTLETMEINBUTTON.alpha = 1.0
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    if defaults.objectForKey("shownRegisterToolTips") == nil {
                        self.showRegisterTooltip()
                        defaults.setBool(true, forKey: "shownRegisterToolTips")
                        defaults.synchronize()
                    }
                    
                    
                    
                })
                
        })
        
        
    }
    
    func goBack() {
        
        self.mode = .Menu
        
        self.tomatoeHeightConstraint.constant = 170
        
        self.pixelVC.setAlternateRowSize(6)
        
        UIView.animateWithDuration(0.6, animations: {
            
            self.view.layoutIfNeeded()
            
            self.email.alpha = 0.0
            self.password.alpha = 0.0
            
            self.backButton.alpha = 0.0
            
            self.email.resignFirstResponder()
            self.password.resignFirstResponder()
            
            
            }, completion: { (completed) in
                
                UIView.animateWithDuration(0.3, animations: {
                    
                    
                    self.SIGNUPBUTTON.alpha = 1.0
                    self.LOGINBUTTON.alpha = 1.0
                    self.JUSTLETMEINBUTTON.alpha = 1.0
                    
                    
                })
                
        })
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        
        if self.mode == .SignupOnly {
            self.dismissViewControllerAnimated(true, completion: { 
                self.goBack()
            })
        }

        else {
            self.goBack()
        }
    }
    
    
    @IBAction func loginPressed(sender: AnyObject) {
        
        
        self.mode = .Login
        
        self.tomatoeHeightConstraint.constant = 100
        
        self.pixelVC.setAlternateRowSize(0)
        
        
        UIView.animateWithDuration(0.6, animations: {
            
            self.view.layoutIfNeeded()
            
            self.SIGNUPBUTTON.alpha = 0.0
            self.LOGINBUTTON.alpha = 0.0
            self.JUSTLETMEINBUTTON.alpha = 0.0
            
            }, completion: { (completed) in
                
                UIView.animateWithDuration(0.3, animations: {
                    
                    self.email.alpha = 1.0
                    self.password.alpha = 1.0
                    
                    self.backButton.alpha = 1.0
                    
                    self.email.becomeFirstResponder()
                    
                })
                
        })
        
    }
    
    
    
    func signup() {
        
        self.tomatoeHeightConstraint.constant = 100
        
        self.pixelVC.setAlternateRowSize(0)
        
        
        UIView.animateWithDuration(0.6, animations: {
            
            self.view.layoutIfNeeded()
            
            self.SIGNUPBUTTON.alpha = 0.0
            self.LOGINBUTTON.alpha = 0.0
            self.JUSTLETMEINBUTTON.alpha = 0.0
            
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
        self.signup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.mode == .Signup {
            
            self.introLabel.alpha = 0.0
        }
        
        self.tomatoeTopSpaceConstraint.constant = 150
        
        
    }
    
    func tooltipPrefs() -> EasyTipView.Preferences {
        
        var preferences = EasyTipView.Preferences()
        
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 16)!
        preferences.drawing.foregroundColor = UIColor.whiteColor()
        preferences.drawing.backgroundColor = UIColor.redColor()
        preferences.drawing.arrowPosition = .Bottom
        preferences.drawing.borderWidth  = 2
        preferences.drawing.borderColor = UIColor.lightGrayColor()
        
        return preferences
    }
    
    
    
    var registerTooltip:EasyTipView!
    
    func showRegisterTooltip() {
        self.registerTooltip = EasyTipView(text: "Ensure your data is saved to the cloud and synced across multiple devices by signing up for a toally free account!", preferences: self.tooltipPrefs(), delegate: self)
        self.registerTooltip.show(animated: true, forView: self.SIGNUPBUTTON, withinSuperview: self.view)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.pixelVC.setupAsPomodoro(6)
        self.view.layoutIfNeeded()
        
        let height = UIScreen.mainScreen().bounds.height
        if height == 568 {
            self.emailTextFieldTopSpacingToTomatoe.constant = 10
            self.emailtoPasswordPaddingConastraint.constant = 10
            
        }
        
        self.tomatoeTopSpaceConstraint.constant = 30
        
        UIView.animateWithDuration(2.8, animations: {
            
            if self.mode == .SignupOnly {
                 self.signup()
            }
            
            self.view.layoutIfNeeded()
            }, completion: { (completed) in
                
                if self.mode != .SignupOnly {
                    if FIRAuth.auth()!.currentUser == nil {
                        
                        UIView.animateWithDuration(1.0, animations: {
                            self.introLabel.alpha = 1.0
                            self.letMeInButton.alpha = 1.0
                        })
                        
                    } else {
                        
                        self.moveToMainScreen()
                    }
                }
                else {
                   
                    
                }
        })
        
        
        
        
        
        
    }
    
    
    func commitAction() {
        
        
        self.password.resignFirstResponder()
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.email.alpha = 0.0
            self.password.alpha = 0.0
            self.backButton.alpha = 0.0
            
        }) { (completed) in
            
            if self.mode == .Login {
                _ = MBProgressHUD.showHUDAddedTo(self.view, animated: false)
                
                FIRAuth.auth()!.signInWithEmail(self.email.text!, password: self.password.text!, completion: { (user, error) in
                    
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    
                    if error == nil {
                        SyncService.sharedInstance.setupSync()
                        
                        self.moveToFinished()
                        
                    }
                    else {
                        UIAlertController.quickMessage((error?.localizedDescription)!, vc: self)
                        
                        
                        
                        
                        self.showEmailAndPasswordAndBackButton()
                    }
                })
                
            }
                
            else if self.mode == .Signup || self.mode == .SignupOnly {
                MBProgressHUD.showHUDAddedTo(self.view, animated: false)
                FIRAuth.auth()!.createUserWithEmail(self.email.text!,password:self.password.text!) { user, error in
                    
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    
                    if error == nil {
                        
                        FIRAuth.auth()!.signInWithEmail(self.email.text!, password: self.password.text!, completion: { (user, error) in
                            if error == nil {
                                SyncService.sharedInstance.setupSync()
                                
                                
                                if self.mode == .SignupOnly {
                                    SyncService.sharedInstance.syncExisting()
                                }
                                
                                self.moveToFinished()
                                
                            }
                            else {
                                UIAlertController.quickMessage((error?.localizedDescription)!, vc: self)
                                self.showEmailAndPasswordAndBackButton()
                                
                            }
                        })
                    }
                    else {
                        
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        UIAlertController.quickMessage((error?.localizedDescription)!, vc: self)
                        
                        self.showEmailAndPasswordAndBackButton()
                    }
                }
            }
        }
    }
    
    
    func showEmailAndPasswordAndBackButton() {
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.email.alpha = 1.0
            self.password.alpha = 1.0
            self.backButton.alpha = 1.0
            
        }) { (complted) in
            self.password.becomeFirstResponder()
            
        }
        
        
    }
    
    func moveToFinished() {
        
        
        
        self.mode = .Menu
        
        self.tomatoeHeightConstraint.constant = 170
        
        
        self.pixelVC.setAlternateRowSize(6)
        
        UIView.animateWithDuration(0.6, animations: {
            
            
            self.SIGNUPBUTTON.alpha = 0.0
            self.LOGINBUTTON.alpha = 0.0
            self.JUSTLETMEINBUTTON.alpha = 0.0
            
            self.view.layoutIfNeeded()
            
            }, completion: { (completed) in
                UIView.animateWithDuration(1.3, animations: {
                    self.introLabel.text = "Thanks, please enjoy POMODOROBAN"
                    self.introLabel.alpha = 1.0
                    
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        
                        self.moveToMainScreen()
                        
                    }
                })
        })
    }
    
    func moveToMainScreen() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("MainNavigationController")
        appDelegate.setRootVC(vc!)
    }
    
    var pixelVC: PixelTestViewController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.pixelVC = segue.destinationViewController as! PixelTestViewController
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


extension LoginViewController : EasyTipViewDelegate {
    func easyTipViewDidDismiss(tipView : EasyTipView) {
    }
}
