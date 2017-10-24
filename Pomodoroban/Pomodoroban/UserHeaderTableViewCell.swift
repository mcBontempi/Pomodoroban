import UIKit

class UserHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWith(name:String) {
        self.nameLabel.text = name
    }


}
