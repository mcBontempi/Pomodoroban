//
//  UIView+Animations.swift
//  nudge
//
//  Created by Daren taylor on 16/02/2016.
//  Copyright © 2016 Buddi. All rights reserved.
//

import UIKit




extension UIView {
  
  func smallBounce(velocity: CGFloat) {
    
      self.transform = CGAffineTransformMakeScale(5.1, 5.1)
      
      UIView.animateWithDuration(1.0,
        delay: 0,
        usingSpringWithDamping: 0.2,
        initialSpringVelocity: velocity,
        options: UIViewAnimationOptions.AllowUserInteraction,
        animations: {
          self.transform = CGAffineTransformIdentity
        }, completion: nil)
    }
  
    func delayedBounce(delay: NSTimeInterval) {
        
        self.transform = CGAffineTransformMakeScale(0.01, 0.01)
        
        UIView.animateWithDuration(0.5,
                                   delay: delay,
                                   usingSpringWithDamping: 0.2,
                                   initialSpringVelocity: 2.0,
                                   options: UIViewAnimationOptions.AllowUserInteraction,
                                   animations: {
                                    self.transform = CGAffineTransformIdentity
                                    self.alpha = 1.0
            }, completion: nil)
    }
    
    
  
}

