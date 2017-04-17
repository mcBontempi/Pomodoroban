import UIKit
import MBProgressHUD

class BuyViewController: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBAction func IChangedMyMindPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    var pixelVC:PixelTestViewController!
    
    @IBAction func restorePurchasesPressed(_ sender: AnyObject) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Products.instance().restoreAllProducts()
    }
    @IBAction func buyPressed(_ sender: AnyObject) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Products.instance().purchaseProduct("1")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.pixelVC.setupAsPomodoro(6)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let product = Products.instance().product(forProductID: "1")
        self.priceLabel.text = product?.price
        
        
    NotificationCenter.default.addObserver(self, selector: #selector(BuyViewController.productsRefreshed), name: NSNotification.Name(rawValue: "productsRefreshed"), object: nil)
        
    }
    
    func productsRefreshed() {
        let product = Products.instance().product(forProductID: "1")
        
        if product?.purchased == true {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pixelSegue" {
            self.pixelVC = segue.destination as! PixelTestViewController
        }
    }
}
