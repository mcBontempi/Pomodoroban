import UIKit

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
  
    func setupWith(title:String) {
        self.titleLabel.text = title
    }
}
