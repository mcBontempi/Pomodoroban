import UIKit

class WebViewController: UIViewController {

    @IBAction func okPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var webView: UIWebView!

    var url:NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = NSURLRequest(URL: self.url)
        
        self.webView.loadRequest(request)
    }
}
