import UIKit

class RootViewController: UIViewController {
    
    
    
    
    
    
    
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var feedView: UIView!
    
    @IBOutlet weak var timerVCTopConstraint: NSLayoutConstraint!
    
    var timerVC: TimerViewController!
    var feedVC: FeedTableViewController!
    var loginVC: LoginViewController!
    
    @IBOutlet weak var timerViewHeight: NSLayoutConstraint!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "timer" {
            self.timerVC = segue.destination as! TimerViewController
        }
        else if segue.identifier == "feed" {
            let nc = segue.destination as! UINavigationController
            
            self.feedVC = nc.viewControllers.first as! FeedTableViewController
        }
        else if segue.identifier == "login" {
            self.loginVC = segue.destination as! LoginViewController
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timerVC.delegate = self
        
        self.loginView.alpha = 1.0
        self.feedView.alpha = 0.0
        self.timerView.alpha = 0.0
        
        self.feedView.isUserInteractionEnabled = false
        self.timerView.isUserInteractionEnabled = false
        self.loginView.isUserInteractionEnabled = true
        self.loginVC.start()
    }
    
    func gotoLogin() {
        UIView.animate(withDuration: 0.3) {
            self.feedView.alpha = 0.0
            self.loginView.alpha = 1.0
        }
        
        self.feedView.isUserInteractionEnabled = false
        self.loginView.isUserInteractionEnabled = true
        
        self.loginVC.mode = .login
        
        self.loginVC.start()
    }
    
    func navigationBarHeight() -> CGFloat {
        let navigationBarHeight: CGFloat = self.feedVC.navigationController!.navigationBar.bounds.origin.y + self.feedVC.navigationController!.navigationBar.frame.size.height
        return navigationBarHeight
    }
    
    func gotoSignUp() {
        UIView.animate(withDuration: 0.3) {
            self.feedView.alpha = 0.0
            self.loginView.alpha = 1.0
        }
        
        self.feedView.isUserInteractionEnabled = false
        self.loginView.isUserInteractionEnabled = true
        
        self.loginVC.mode = .signupOnly
        
        self.loginVC.start()
    }
    
    
    
    
    
    func gotoTimer() -> TimerViewController{
        
        self.updateTimerHeight()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.timerView.alpha = 1.0
            
            self.timerView.layoutIfNeeded()
        }) { (bool) in
            self.feedVC.navigationController?.popToRootViewController(animated: false)
        }
        
        self.timerView.isUserInteractionEnabled = true
        
        return self.timerVC
    }
    
    func hideTimer() {
        UIView.animate(withDuration: 0.3) {
            self.timerView.alpha = 0.0
        }
        self.timerView.isUserInteractionEnabled = false
    }
    
    func gotoFeed() {
        UIView.animate(withDuration: 0.3) {
            self.feedView.alpha = 1.0
            self.loginView.alpha = 0.0
        }
        
        self.feedView.isUserInteractionEnabled = true
        self.loginView.isUserInteractionEnabled = false
        
        self.feedVC.reloadTable()
    }
    
    var timerHeight:TimerHeight {
        get {
            let defaults = UserDefaults.standard
            if let _ = defaults.object(forKey: "timerHeight")  {
                let value = defaults.value(forKey: "timerHeight") as! Int
                defaults.synchronize()
                return TimerHeight(rawValue:value)!
            }
            return .TimerHeightFullScreen
        }
        set (newTimerHeight){
            let defaults = UserDefaults.standard
            let value = newTimerHeight.rawValue
            defaults.set(value, forKey: "timerHeight")
            defaults.synchronize()
        }
    }
    
    func updateTimerHeight() {
        switch (self.timerHeight) {
        case .TimerHeightFullScreen:
            self.timerViewHeight.constant = UIScreen.main.bounds.size.height
        default:
            self.timerViewHeight.constant = 100
        }
        
        UIView.animate(withDuration: 3.0, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    enum TimerHeight : Int {
        case TimerHeightFullScreen = 0
        case TimerHeightMini = 1
    }

}


extension RootViewController : TimerViewControllerDelegate {
    func timerViewControllerEnded(_ timerViewController: TimerViewController) {
        self.feedVC.reloadTable()
    }
    
    func timerViewControllerDidPressResize(_ timerViewController: TimerViewController) {
        self.timerHeight = [.TimerHeightMini, .TimerHeightFullScreen][self.timerHeight.rawValue]
        
        self.updateTimerHeight()
    }
}
