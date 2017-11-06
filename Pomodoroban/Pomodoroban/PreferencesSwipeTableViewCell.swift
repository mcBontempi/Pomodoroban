import UIKit
import FirebaseAuth

protocol PreferencesSwipeTableViewCellDelegate {
    func signOut()
    func registerForSync()
}

class PreferencesSwipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: PreferencesSwipeTableViewCellDelegate?
    
    
    func setupWith(delegate: PreferencesSwipeTableViewCellDelegate) {
        self.delegate = delegate
        
        self.collectionView.reloadData()
    }
    
    var selectedItem = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
    }
    
    func isLoggedIn() -> Bool {
        return  Auth.auth().currentUser?.uid != nil
    }
}

extension PreferencesSwipeTableViewCell : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 0:
            self.delegate?.signOut()
        case 1:
            self.delegate?.registerForSync()
        default:
            break
            
        }
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
    }
}
extension PreferencesSwipeTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "prefsCell", for: indexPath) as! SquareButtonCollectionViewCell
        
        cell.setupWith(title: ["Sign Out"][indexPath.row])
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.borderColor = UIColor.red.cgColor
        
        return cell
    }
}

extension PreferencesSwipeTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = UIScreen.main.bounds.width
        
        width = width - 50
        
        width = width / 4
        
        return CGSize(width:width,height:70)
    }
}



