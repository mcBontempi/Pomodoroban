import UIKit

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var border: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.border.layer.borderColor = UIColor.red.cgColor
        self.border.layer.borderWidth = 2
        self.border.layer.cornerRadius = 4
    }
    
    func setupWith(title:String) {
    self.titleLabel.text = title
    }
    
    
}
