import UIKit

class WebViewController: UIViewController {

    @IBAction func okPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var webView: UIWebView!

    var url:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = URLRequest(url: self.url)
        
        self.webView.loadRequest(request)
    }
}
