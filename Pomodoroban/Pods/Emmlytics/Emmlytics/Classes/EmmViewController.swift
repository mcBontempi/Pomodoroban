import UIKit
import Foundation


open class emmViewController: UIViewController {
    
    @IBAction func sendAnalytic(_ sender: Any) {
        
        Emmlytics().sendAnalytics(event:"ButtonPress")
        
    }
    
    @IBOutlet weak var feedTXTview: UITextView!
    
    @IBAction func btnHappy(_ sender: Any) {
        Emmlytics().sendFeedback(feedback: self.feedTXTview.text!,rating: 3)
        self.dismiss(animated:true)
    }
    @IBAction func btnMeh(_ sender: Any) {
        Emmlytics().sendFeedback(feedback: self.feedTXTview.text!,rating: 2)
        self.dismiss(animated:true)
    }
    @IBAction func btnSad(_ sender: Any) {
        Emmlytics().sendFeedback(feedback: self.feedTXTview.text!,rating: 1)
        self.dismiss(animated:true)
    }
   }



