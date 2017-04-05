import UIKit
import SwiftHEXColors

extension UIColor {
    
    
    class func colorArray() -> [UIColor] {
        let array = [UIColor.black, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.red, UIColor.white]
        return array
    }
    
    class func colorFrom(_ paletteIndex: Int) -> UIColor {
        
        return UIColor.colorArray()[paletteIndex]
    }
    
    
}
