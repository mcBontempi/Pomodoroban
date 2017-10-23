import UIKit
import DDTRepeater

class InfoViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var repeater:DDTRepeater?
    
    var stringBlock:((Void) -> String)! {
        didSet {
            self.repeater = DDTRepeater.repeater(1) {
                if let label = self.label {
                    label.text = self.stringBlock()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = self.stringBlock()
    }
}
