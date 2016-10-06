import UIKit
import SwiftHEXColors

extension UIColor {
    
     class func colorFrom(paletteIndex: Int) -> UIColor {
     
        let rgbArray = ["FF0000", "FF8000","FFFF00","80FF00","00FF00","00FF80","00FFFF","0080FF","0000FF","7F00FF","FF00FF","FF007D","808080"]
        
        let rgb = rgbArray[paletteIndex]
        
        return UIColor(hexString: rgb)!
    }
}
