import UIKit

class CreateCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var title: UILabel!
    func setupWith(title:String){
        self.title.text = title
    }
    
}
