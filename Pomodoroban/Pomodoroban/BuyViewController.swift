import UIKit

class BuyViewController: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBAction func IChangedMyMindPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    var pixelVC:PixelTestViewController!
    
    @IBAction func restorePurchasesPressed(sender: AnyObject) {
        
        Products.instance().restoreAllProducts()
    }
    @IBAction func buyPressed(sender: AnyObject) {
        Products.instance().purchaseProduct("1")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.pixelVC.setupAsPomodoro(6)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let product = Products.instance().productForProductID("1")
        
        self.priceLabel.text = product.price
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pixelSegue" {
            self.pixelVC = segue.destinationViewController as! PixelTestViewController
        }
    }
}
