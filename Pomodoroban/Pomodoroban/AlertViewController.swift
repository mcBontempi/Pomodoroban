import UIKit

protocol AlertViewControllerDelegate {
    func done()
}

class AlertViewController: UIViewController {
    
    var delegate: AlertViewControllerDelegate?
    
    @IBOutlet weak var titleMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleMessage.layer.cornerRadius = 10
        self.titleMessage.layer.borderColor = UIColor.red.cgColor
        self.titleMessage.layer.borderWidth = 3
    }
    
    @IBAction func sharePressed(_ sender: Any) {
    }
    
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupWith(titleMessage:String, delegate: AlertViewControllerDelegate) {
        
        self.titleMessage.text = titleMessage
        
        self.delegate = delegate
    }
    
}
