import UIKit

protocol CreateSwipeTableViewCellDelegate {
    func createIn(section:String)
}

class CreateSwipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: CreateSwipeTableViewCellDelegate?
    
    
    func setupWith(delegate: CreateSwipeTableViewCellDelegate) {
        self.delegate = delegate
    }
    
    var selectedItem = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
  
    }
}

extension CreateSwipeTableViewCell : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.createIn(section:["Backlog","Morning","Afternoon","Evening"][indexPath.row])
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
  
    }
}
extension CreateSwipeTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"addToBacklog", for: indexPath) as! SquareButtonCollectionViewCell
        
        cell.setupWith(title: ["Add to Backlog","Add to Morning", "Add to Afternoon", "Add to Evening"][indexPath.row])
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.borderColor = UIColor.red.cgColor
        
        return cell
    }
}

extension CreateSwipeTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = UIScreen.main.bounds.width
        
        width = width - 50
        
        width = width / 4
        
        return CGSize(width:width,height:70)
    }
}

