import UIKit
import DDTRepeater

protocol CreateSwipeTableViewCellDelegate {
    func addToBacklog()
    func showBoard()
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
        
        if indexPath.item == 0 {
            self.delegate?.addToBacklog()
        }
        else if indexPath.item == 1 {
            self.delegate?.showBoard()
        }
    }
}
extension CreateSwipeTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ["addToBacklog","addToBacklog","addToBacklog"][indexPath.row], for: indexPath) as! CreateCollectionViewCell
        
        cell.setupWith(title: ["Add task to Backlog","Advanced Editor", "Does Nothing"][indexPath.row])
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.borderColor = UIColor.red.cgColor
        
        return cell
    }
}

extension CreateSwipeTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:80,height:80)
    }
}

