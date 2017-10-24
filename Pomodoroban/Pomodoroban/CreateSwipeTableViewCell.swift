import UIKit
import DDTRepeater

protocol CreateSwipeTableViewCellDelegate {
    func addToBacklog()
}

class CreateSwipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: CreateSwipeTableViewCellDelegate?
    
    
    func setupWith(delegate: CreateSwipeTableViewCellDelegate) {
        self.delegate = delegate
    }
    
    
    
    
    var repeater:DDTRepeater?
    var selectedItem = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.repeater?.invalidate()
        self.repeater = DDTRepeater.repeater(10.0, fireOnceInstantly: false) {
            self.showNextPage(animated: true)
        }
    }
    
    func showNextPage(animated:Bool) {
        
        let indexPath = IndexPath(item: self.selectedItem, section: 0)
        
        self.selectedItem = self.selectedItem + 1
        
        if self.selectedItem == 3 {
            self.selectedItem = 0
        }
        
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        
    }
}

extension CreateSwipeTableViewCell : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.addToBacklog()
    }
    
}
extension CreateSwipeTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: ["addToBacklog","addToBacklog","addToBacklog"][indexPath.row], for: indexPath)
    }
}

extension CreateSwipeTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:80,height:80)
    }
    
}

