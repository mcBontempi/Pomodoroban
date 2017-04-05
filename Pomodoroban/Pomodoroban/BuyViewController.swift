import UIKit

class BuyViewController: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBAction func IChangedMyMindPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    var pixelVC:PixelTestViewController!
    
    @IBAction func restorePurchasesPressed(_ sender: AnyObject) {
        
        Products.instance().restoreAllProducts()
    }
    @IBAction func buyPressed(_ sender: AnyObject) {
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pixelSegue" {
            self.pixelVC = segue.destination as! PixelTestViewController
        }
    }
}
