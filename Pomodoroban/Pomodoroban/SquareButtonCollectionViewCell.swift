import UIKit

class SquareButtonCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var title: UILabel!
    func setupWith(title:String){
        self.title.text = title
    }
    
    override var isHighlighted:Bool {
        get {
            return super.isHighlighted
        }
        set {
            super.isHighlighted = newValue
            self.contentView.backgroundColor = newValue ? UIColor.red : UIColor.white
            
            self.title.textColor = newValue ? UIColor.white : UIColor.darkGray
        }
    }
}
