import UIKit
import SwiftHEXColors

extension UIView {
    
    class func pomodoroRowWith(_ count: Int) -> UIView {
        
        let pomodoroSize:CGFloat = 24
        
        var x:CGFloat = 0
        
        let view = UIView()
        
        for _ in 0 ..< count {
            
            let image = UIImageView(image: UIImage(named:"Pomodoro-Timer"))
            
            
            view.addSubview(image)
            
            image.frame = CGRect(x: x,y: 0,width: pomodoroSize,height: pomodoroSize)
            
            x = x + pomodoroSize
            
        }
        
        view.frame = CGRect(x: 0,y: 0,width: x,height: pomodoroSize)
        
        return view
    }
}
