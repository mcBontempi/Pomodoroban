//
//  UIView+Animations.swift
//  nudge
//
//  Created by Daren taylor on 16/02/2016.
//  Copyright © 2016 Buddi. All rights reserved.
//

import UIKit




extension UIView {
  
  func smallBounce(_ velocity: CGFloat) {
    
      self.transform = CGAffineTransform(scaleX: 5.1, y: 5.1)
      
      UIView.animate(withDuration: 1.0,
        delay: 0,
        usingSpringWithDamping: 0.2,
        initialSpringVelocity: velocity,
        options: UIViewAnimationOptions.allowUserInteraction,
        animations: {
          self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
  
    func delayedBounce(_ delay: TimeInterval) {
        
        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 0.5,
                                   delay: delay,
                                   usingSpringWithDamping: 0.2,
                                   initialSpringVelocity: 2.0,
                                   options: UIViewAnimationOptions.allowUserInteraction,
                                   animations: {
                                    self.transform = CGAffineTransform.identity
                                    self.alpha = 1.0
            }, completion: nil)
    }
    
    
  
}

