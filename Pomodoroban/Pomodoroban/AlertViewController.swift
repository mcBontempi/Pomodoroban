import UIKit
import FBSDKShareKit

protocol AlertViewControllerDelegate {
    func done()
}

class AlertViewController: UIViewController {
    
    @IBOutlet weak var calchuaLogo: UIImageView!
    @IBOutlet weak var shareButton: FBSDKShareButton!
    var alert: Alert!
    
    var delegate: AlertViewControllerDelegate?
    
    @IBOutlet weak var titleMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let delayTime = DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
        self.pixelVC.setupAsPomodoro(6)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.calchuaLogo.alpha = 1.0
            })
            
            UIView.animate(withDuration: 0.6, animations: {
                self.titleMessage.alpha = 1.0
            })
            
            UIView.animate(withDuration: 1.0, animations: {
                self.shareButton.alpha = 1.0
            })
            
        }
        
        self.titleMessage.text = self.alert.message
        
        self.shareButton.isEnabled = true
        
        let content:FBSDKShareLinkContent = FBSDKShareLinkContent()
       
        let alertType = alert.type
        
        content.contentURL = URL(string:"http://calchua.com/alert\(alertType)")
        
        self.shareButton.shareContent = content
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        
        
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupWith(alert:Alert, delegate: AlertViewControllerDelegate) {
        
        self.alert = alert
        
        self.delegate = delegate
    }
    var pixelVC: PixelTestViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "pixelSegue" {
            self.pixelVC = segue.destination as! PixelTestViewController
        }
    }
    
}
