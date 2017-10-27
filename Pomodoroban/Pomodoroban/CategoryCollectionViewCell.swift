import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderColor = UIColor.darkGray.cgColor
        self.contentView.layer.cornerRadius = self.frame.size.width / 2
        self.contentView.clipsToBounds = true
    }
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            super.isSelected = newValue
            self.contentView.layer.borderWidth = newValue ? 7 : 0
        }
    }
}
