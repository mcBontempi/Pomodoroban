import UIKit

class SessionTableViewCell: UITableViewCell {

    @IBOutlet weak var chevron: UIImageView!
    @IBOutlet weak var name: UILabel!
 
    func setupWith(name:String) {
        self.name.text = name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.chevron?.miniBounce(1.0)
        self.name?.miniBounce(1.0)
    }
}
