import UIKit
import SwiftHEXColors

extension UIColor {
    
    
    class func colorArray() -> [UIColor] {
        let array = [UIColor(hex: 0xb4342f)!, UIColor(hex:0xe47a47)!, UIColor(hex:0xf3b950)!, UIColor(hex:0x317677)! , UIColor(hex:0x762139)!]
        return array
    }
    
    class func colorFrom(_ paletteIndex: Int) -> UIColor {
        
        return UIColor.colorArray()[paletteIndex]
    }
    
    
}
