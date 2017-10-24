import UIKit

class SessionTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupWith(name:String) {
        self.name.text = name
    }
}
