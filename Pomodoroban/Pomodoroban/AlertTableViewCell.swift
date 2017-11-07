import UIKit

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupWith(title:String) {
    self.titleLabel.text = title
    }
    
    
}
