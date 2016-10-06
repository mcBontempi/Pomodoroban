import UIKit
import SwiftHEXColors

extension UIView {
    
    class func pomodoroRowWith(count: Int) -> UIView {
        
        let pomodoroSize:CGFloat = 24
        
        var x:CGFloat = 0
        
        let view = UIView()
        
        for _ in 0 ..< count {
            
            let image = UIImageView(image: UIImage(named:"Pomodoro-Timer"))
            
            
            view.addSubview(image)
            
            image.frame = CGRectMake(x,0,pomodoroSize,pomodoroSize)
            
            x = x + pomodoroSize
            
        }
        
        view.frame = CGRectMake(0,0,x,pomodoroSize)
        
        return view
    }
}
