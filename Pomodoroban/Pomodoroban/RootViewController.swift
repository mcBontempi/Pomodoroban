import UIKit

class RootViewController: UIViewController {
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var feedView: UIView!

    var timerVC: TimerViewController!
    var feedVC: FeedTableViewController!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "timer" {
            self.timerVC = segue.destination as! TimerViewController
        }
        else if segue.identifier == "feed" {
            let nc = segue.destination as! UINavigationController
            
            self.feedVC = nc.viewControllers.first as! FeedTableViewController
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
    }

    func gotoLogin() {
        UIView.animate(withDuration: 0.3) {
            self.feedView.alpha = 0.0
            self.loginView.alpha = 1.0
        }
        
        self.feedView.isUserInteractionEnabled = false
        self.loginView.isUserInteractionEnabled = true
    }
    
    func gotoTimer() -> TimerViewController{
        UIView.animate(withDuration: 0.3, animations: {
               self.timerView.alpha = 1.0
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
    }
}


extension RootViewController : TimerViewControllerDelegate {
    func timerViewControllerEnded(_ timerViewController: TimerViewController) {
        self.feedVC.reloadTable()
    }
}
