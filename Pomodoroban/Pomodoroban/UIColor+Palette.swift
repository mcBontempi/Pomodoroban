import UIKit
import SwiftHEXColors

extension UIColor {
    
    
    class func colorArray() -> [UIColor] {
        let array = [UIColor.blackColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.redColor(), UIColor.whiteColor()]
        return array
    }
    
    class func colorFrom(paletteIndex: Int) -> UIColor {
        
        return UIColor.colorArray()[paletteIndex]
    }
    
    
}
