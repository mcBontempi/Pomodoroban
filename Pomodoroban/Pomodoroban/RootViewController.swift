import UIKit

enum TimerHeight : Int {
    case TimerHeightFullScreen = 0
    case TimerHeightMini = 1
}

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
        
        self.timerHeight = .TimerHeightFullScreen
        
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
        
        self.moveToTop(animated: false)
        
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
    
    var timerHeight:TimerHeight!
}

extension RootViewController : TimerViewControllerDelegate {
    func timerViewControllerEnded(_ timerViewController: TimerViewController) {
        self.feedVC.reloadTable()
    }
    
    func timerViewControllerDidPressResize(_ timerViewController: TimerViewController) {
        self.timerHeight = [.TimerHeightMini, .TimerHeightFullScreen][self.timerHeight.rawValue]
        
        self.timerVC.timerHeight = self.timerHeight
    }
    
    func moveToTop(animated: Bool) {
        self.timerViewHeight.constant = UIScreen.main.bounds.size.height
        if animated == true {
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
            })
        }
        else {
            self.view.setNeedsLayout()
        }
    }
    
    func moveToBottom(animated: Bool) {
        self.timerViewHeight.constant = 100
        if animated == true {
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
            })
        }
        else {
            self.view.setNeedsLayout()
        }
    }
}
