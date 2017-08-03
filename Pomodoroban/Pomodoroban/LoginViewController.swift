import UIKit
import Firebase
import FirebaseAuth
import MBProgressHUD
import EasyTipView

protocol LoginViewControllerDelegate : class {
    func loginViewControllerDidSignIn(_ loginViewController:LoginViewController)
}

enum Mode {
    case welcome
    case menu
    case login
    case signup
    case signupOnly
    case sendPassword
}

class LoginViewController: UIViewController {
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var skepticsButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "privacySegue" || segue.identifier == "skepticsSegue" {
            let popoverViewController = segue.destination as! WebViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
            
            popoverViewController.preferredContentSize = UIScreen.main.bounds.insetBy(dx: 0,dy: 40).size
            
            popoverViewController.url = segue.identifier == "privacySegue" ? URL(string:"http://www.pomodoroban.com/privacy.html") : URL(string:"htxxtp://www.pomodoroban.com/skeptics_faq.html")
            
        }
        else if segue.identifier == "pixelSegue" {
            self.pixelVC = segue.destination as! PixelTestViewController
        }
    }
    
    var mode:Mode = .welcome
    
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
    @IBOutlet weak var FORGOTPASSWORDBUTTON: UIButton!
    
    func signinFirebaseAccount(_ email:String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
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
    
    
    func cornerView(_ view:UIView,radius:CGFloat) {
        view.layer.cornerRadius = radius
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in [self.letMeInButton, self.SIGNUPBUTTON,self.LOGINBUTTON, self.JUSTLETMEINBUTTON, self.FORGOTPASSWORDBUTTON] {
            self.cornerView(view!,radius:5)
        }
        
        skepticsButton.alpha = 0.0
        privacyButton.alpha = 0.0
        
        
        
    }
    
    func clearFields() {
        self.password.text = ""
        self.email.text = ""
    }
    
    @IBAction func forgotPasswordPressed(_ sender: AnyObject) {
        
        self.clearFields()
        
        self.mode = .sendPassword
        
        self.tomatoeHeightConstraint.constant = 100
        
        self.pixelVC.setAlternateRowSize(0)
        
        
        UIView.animate(withDuration: 0.6, animations: {
            
            self.view.layoutIfNeeded()
            
            self.SIGNUPBUTTON.alpha = 0.0
            self.LOGINBUTTON.alpha = 0.0
            self.JUSTLETMEINBUTTON.alpha = 0.0
            self.FORGOTPASSWORDBUTTON.alpha = 0.0
            
            }, completion: { (completed) in
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.email.alpha = 1.0
                    self.backButton.alpha = 1.0
                    self.email.becomeFirstResponder()
                })
                
        })
        
    }
    
    @IBAction func justLetMeInPressed(_ sender: AnyObject) {
        
        
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "loggedInWithoutAuth") == nil {
            defaults.set(true, forKey: "loggedInWithoutAuth")
            defaults.synchronize()
        }
        
        
        self.moveToFinished()
        
    }
    
    @IBAction func letMeInPressed(_ sender: AnyObject) {
        
        self.mode = .menu
        
        UIView.animate(withDuration: 0.3, animations: {
            self.introLabel.alpha = 0.0
            self.letMeInButton.alpha = 0.0
            
            
            }, completion: { (completed) in
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.SIGNUPBUTTON.alpha = 1.0
                    self.LOGINBUTTON.alpha = 1.0
                    self.JUSTLETMEINBUTTON.alpha = 1.0
                    self.FORGOTPASSWORDBUTTON.alpha = 1.0
                    
                    let defaults = UserDefaults.standard
                    
                    if defaults.object(forKey: "shownRegisterToolTips") == nil {
                        self.showRegisterTooltip()
                        defaults.set(true, forKey: "shownRegisterToolTips")
                        defaults.synchronize()
                    }
                    
                    
                    
                })
                
        })
        
        
    }
    
    func goBack() {
        
        self.mode = .menu
        
        self.tomatoeHeightConstraint.constant = 170
        
        self.pixelVC.setAlternateRowSize(6)
        
        UIView.animate(withDuration: 0.6, animations: {
            
            self.view.layoutIfNeeded()
            
            self.email.alpha = 0.0
            self.password.alpha = 0.0
            
            self.backButton.alpha = 0.0
            
            self.email.resignFirstResponder()
            self.password.resignFirstResponder()
            
            
            }, completion: { (completed) in
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    
                    self.SIGNUPBUTTON.alpha = 1.0
                    self.LOGINBUTTON.alpha = 1.0
                    self.JUSTLETMEINBUTTON.alpha = 1.0
                    self.FORGOTPASSWORDBUTTON.alpha = 1.0
                    
                    
                })
                
        })
    }
    
    @IBAction func backPressed(_ sender: AnyObject) {
        
        if self.mode == .signupOnly {
            self.dismiss(animated: true, completion: {
                self.goBack()
            })
        }
            
        else {
            self.goBack()
        }
    }
    
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        self.clearFields()
        
        self.mode = .login
        
        self.tomatoeHeightConstraint.constant = 100
        
        self.pixelVC.setAlternateRowSize(0)
        
        
        UIView.animate(withDuration: 0.6, animations: {
            
            self.view.layoutIfNeeded()
            
            self.SIGNUPBUTTON.alpha = 0.0
            self.LOGINBUTTON.alpha = 0.0
            self.JUSTLETMEINBUTTON.alpha = 0.0
            self.FORGOTPASSWORDBUTTON.alpha = 0.0
            
            }, completion: { (completed) in
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.email.alpha = 1.0
                    self.password.alpha = 1.0
                    
                    self.backButton.alpha = 1.0
                    
                    self.email.becomeFirstResponder()
                    
                })
                
        })
        
    }
    
    
    
    func signup() {
        
        self.clearFields()
        
        self.tomatoeHeightConstraint.constant = 100
        
        self.pixelVC.setAlternateRowSize(0)
        
        
        UIView.animate(withDuration: 0.6, animations: {
            
            self.view.layoutIfNeeded()
            
            self.SIGNUPBUTTON.alpha = 0.0
            self.LOGINBUTTON.alpha = 0.0
            self.JUSTLETMEINBUTTON.alpha = 0.0
            self.FORGOTPASSWORDBUTTON.alpha = 0.0
            
            }, completion: { (completed) in
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.email.alpha = 1.0
                    self.password.alpha = 1.0
                    
                    
                    
                    self.backButton.alpha = 1.0
                    
                    self.email.becomeFirstResponder()
                    
                })
                
        })
        
    }
    
    @IBAction func signupPressed(_ sender: AnyObject) {
        self.mode = .signup
        self.signup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        
        var alpha:CGFloat = 0.0
        
        if Auth.auth().currentUser == nil && defaults.object(forKey: "loggedInWithoutAuth") == nil  {
            
            alpha = 1.0
            
        }
        
        UIView.animate(withDuration: 0.6, animations: { 
            
            self.privacyButton.alpha = alpha
            self.skepticsButton.alpha = alpha
            
        }) 
        
        
        if self.mode == .signup {
            self.introLabel.alpha = 0.0
        }
        
        self.tomatoeTopSpaceConstraint.constant = 150
        
        
    }
    
    func tooltipPrefs() -> EasyTipView.Preferences {
        
        var preferences = EasyTipView.Preferences()
        
        preferences.drawing.font = UIFont(name: "Futura-Medium", size: 16)!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = UIColor.red
        preferences.drawing.arrowPosition = .bottom
        preferences.drawing.borderWidth  = 2
        preferences.drawing.borderColor = UIColor.lightGray
        
        return preferences
    }
    
    
    
    var registerTooltip:EasyTipView!
    
    func showRegisterTooltip() {
        self.registerTooltip = EasyTipView(text: "Ensure your data is saved to the cloud and synced across multiple devices by signing up for a totally free account!", preferences: self.tooltipPrefs(), delegate: self)
        self.registerTooltip.show(animated: true, forView: self.SIGNUPBUTTON, withinSuperview: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let delayTime = DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {

        
        self.pixelVC.setupAsPomodoro(6)
        self.view.layoutIfNeeded()
        
        let height = UIScreen.main.bounds.height
        if height == 568 {
            self.emailTextFieldTopSpacingToTomatoe.constant = 10
            self.emailtoPasswordPaddingConastraint.constant = 10
            
        }
        
        self.tomatoeTopSpaceConstraint.constant = 30
        
            
            print (ProcessInfo.processInfo.environment)
            
            var duration = 2.8
            
            if TARGET_IPHONE_SIMULATOR == 1 {
                duration = 0.1
             //   delay = 0.2
            }
            
            
            
        UIView.animate(withDuration: duration, animations: {
            
            if self.mode == .signupOnly {
                self.signup()
            }
            
            
            
            
            self.view.layoutIfNeeded()
            }, completion: { (completed) in
                
                if self.mode != .signupOnly {
                    
                    
                    let defaults = UserDefaults.standard
                    
                    if Auth.auth().currentUser == nil && defaults.object(forKey: "loggedInWithoutAuth") == nil  {
                        
                        UIView.animate(withDuration: 1.0, animations: {
                            self.introLabel.alpha = 1.0
                            self.letMeInButton.alpha = 1.0
                        })
                        
                    } else {
                        
                          SyncService.sharedInstance.setupSync()
                        
                        self.moveToMainScreen()
                        
                    }
                }
                else {
                    
                    
                }
        })
        
        
        }
        
        
        
    }
    
    
    func commitAction() {
        
        
        self.password.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.email.alpha = 0.0
            self.password.alpha = 0.0
            self.backButton.alpha = 0.0
            
        }, completion: { (completed) in
            
            if self.mode == .login {
                _ = MBProgressHUD.showAdded(to: self.view, animated: false)
                
                Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error) in
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if error == nil {
                        SyncService.sharedInstance.setupSync()
                        
                        self.moveToFinished()
                        
                    }
                    else {
                        
                        
                        
                        
                        self.showEmailAndPasswordAndBackButton()
                        UIAlertController.quickMessage((error?.localizedDescription)!, vc: self)
                    }
                })
                
            }
            else if self.mode == .sendPassword {
                _ = MBProgressHUD.showAdded(to: self.view, animated: false)
                
                Auth.auth().sendPasswordReset(withEmail: self.email.text!, completion: { (error) in
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if error == nil {
                        
                        self.goBack()
                        UIAlertController.quickMessage("Check your email for a further verication step", vc: self)
                    }
                    else {
                        
                        self.showEmailAndBackButton()
                        UIAlertController.quickMessage((error?.localizedDescription)!, vc: self)
                    }
                })
                
            }
                
                
            else if self.mode == .signup || self.mode == .signupOnly {
                MBProgressHUD.showAdded(to: self.view, animated: false)
                Auth.auth().createUser(withEmail: self.email.text!,password:self.password.text!) { user, error in
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if error == nil {
                        
                        Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error) in
                            if error == nil {
                                SyncService.sharedInstance.setupSync()
                                
                                
                                if self.mode == .signupOnly {
                                    SyncService.sharedInstance.syncExisting()
                                }
                                
                                self.moveToFinished()
                                
                            }
                            else {
                                self.showEmailAndPasswordAndBackButton()
                                UIAlertController.quickMessage((error?.localizedDescription)!, vc: self)
                                
                            }
                        })
                    }
                    else {
                        
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        self.showEmailAndPasswordAndBackButton()
                        UIAlertController.quickMessage((error?.localizedDescription)!, vc: self)
                    }
                }
            }
        }) 
    }
    
    
    func showEmailAndBackButton() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.email.alpha = 1.0
            self.backButton.alpha = 1.0
            
        }, completion: { (complted) in
            self.password.becomeFirstResponder()
            
        }) 
        
        
    }
    
    
    func showEmailAndPasswordAndBackButton() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.email.alpha = 1.0
            self.password.alpha = 1.0
            self.backButton.alpha = 1.0
            
        }, completion: { (complted) in
            self.password.becomeFirstResponder()
            
        }) 
        
        
    }
    
    func moveToFinished() {
        
        
        
        self.mode = .menu
        
        self.tomatoeHeightConstraint.constant = 170
        
        
        self.pixelVC.setAlternateRowSize(6)
        
        UIView.animate(withDuration: 0.6, animations: {
            
            
            self.SIGNUPBUTTON.alpha = 0.0
            self.LOGINBUTTON.alpha = 0.0
            self.JUSTLETMEINBUTTON.alpha = 0.0
            self.FORGOTPASSWORDBUTTON.alpha = 0.0
            
            self.view.layoutIfNeeded()
            
            }, completion: { (completed) in
                
                var duration = 1.3
                var delay = 2.0
                
                print (ProcessInfo.processInfo.environment)
                
                if ProcessInfo.processInfo.environment["iPhone 7 Plus"] != nil {
                    duration = 0.1
                    delay = 0.2
                }
                
                UIView.animate(withDuration: duration, animations: {
                    self.introLabel.text = "Thanks, please enjoy POMODOROBAN"
                    self.introLabel.alpha = 1.0
                    
                    let delayTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: delayTime) {
                        
                        self.moveToMainScreen()
                        
                    }
                })
        })
    }
    
    func moveToMainScreen() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigationController")
        appDelegate.setRootVC(vc!)
    }
    
    var pixelVC: PixelTestViewController!
    
}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.email {
            
            if self.mode == .sendPassword {
                self.commitAction()
            }
            else {
                
                self.password.becomeFirstResponder()
            }
        }
        else if textField == self.password {
            self.commitAction()
        }
        return true
    }
}


extension LoginViewController : EasyTipViewDelegate {
    func easyTipViewDidDismiss(_ tipView : EasyTipView) {
    }
}


extension LoginViewController : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
