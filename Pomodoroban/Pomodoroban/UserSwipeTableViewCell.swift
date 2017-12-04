import UIKit
import DDTRepeater

class UserSwipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var repeater:DDTRepeater?
    var selectedItem = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.repeater?.invalidate()
        self.repeater = DDTRepeater.repeater(2.0, fireOnceInstantly: false) {
            self.showNextPage(animated: true)
        }
    }
    
    func showNextPage(animated:Bool) {
        
        let indexPath = IndexPath(item: self.selectedItem, section: 0)
        
        self.selectedItem = self.selectedItem + 1
        
        if self.selectedItem == 2 {
            self.selectedItem = 0
        }
        
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        
    }
}

extension UserSwipeTableViewCell : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
    }
    
    
}
extension UserSwipeTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ["youTube","daren"][indexPath.row], for: indexPath)
        
        cell.contentView.layer.cornerRadius = 10
        
        return cell
    }
}

extension UserSwipeTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:UIScreen.main.bounds.width,height:110)
    }
    
}

