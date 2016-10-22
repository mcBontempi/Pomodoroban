//
//  PixelTestViewController.swift
//  Pomodoroban
//
//  Created by Daren taylor on 20/10/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit
import LSRepeater




class PixelTestViewController: UIViewController {

    enum Mode {
        case None
        case Pomodoro
        case Cup
        case Food
    }

    
    var mode:Mode = .None
    
    var widthAndHeightConstraints = [NSLayoutConstraint]()
    
  var repeater:LSRepeater!
  
  var viewIndex = 0
    
    func setupAsCup(size:CGFloat) {
        
      
        if mode != .Cup {
            self.mode = .Cup
            self.removeAll()
            
            let pixels = [[3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],
                         [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]]
            
            self.setupWithPixels(pixels, size:size)
            
        }
        
    }
    
    func setupAsFood(size:CGFloat) {
        
        if self.mode != .Food {
            self.mode = .Food
            self.removeAll()
            
            let pixels = [[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],
                        [4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4],[4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4]]
            
            self.setupWithPixels(pixels, size:size)
            
        }
    }
    
    func removeAll() {
        self.widthAndHeightConstraints.removeAll()
    
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
    }
    
    
    func setupAsPomodoro(size:CGFloat) {
        
        if self.mode != .Pomodoro {
            
            self.mode = .Pomodoro
            
            self.removeAll()
            
    let pixels = [[0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,2,2,2,0,0,2,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,2,2,2,0,2,0,2,2,2,2,0,0,0,0,0,0],
    [0,0,0,1,1,1,1,0,0,0,2,2,2,2,2,2,2,0,0,0,1,0,0,0],
    [0,0,1,1,1,1,1,0,2,2,2,0,2,2,2,2,2,0,2,0,1,1,0,0],
    [0,1,1,1,1,0,0,2,2,2,2,2,2,0,2,2,2,2,0,0,1,1,1,0],
    [0,1,1,1,0,0,2,2,2,2,0,2,2,2,0,0,2,2,0,0,1,1,1,0],
    [0,1,1,1,1,0,0,0,0,0,0,0,2,2,0,0,0,0,0,1,1,1,1,1],
    [1,1,1,1,1,1,1,1,1,1,1,0,2,2,0,1,1,1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],
    [0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0],
    [0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0],
    [0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0],
    [0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0]]
    
            self.setupWithPixels(pixels, size:size)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.view.backgroundColor = UIColor.clearColor()
      
  }
    
    
    
    func setupWithPixels(pixels:[[Int]], size:CGFloat) {
        
    var delay:Double = 0.0
    
    var y:CGFloat = 1
    
    for row in pixels {
    
    var x:CGFloat = 1
    
    for pixel in row {
    
    if pixel != 0 {
    
    let view = UIView(frame:CGRectZero)
    view.tag = 1
    view.layer.cornerRadius = size / 2
   
        
        
        
        
        view.backgroundColor = [UIColor.grayColor(),UIColor.redColor(),UIColor.greenColor(), UIColor.blueColor(), UIColor.yellowColor()][pixel]
    
    self.view.addSubview(view)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    
    
    var constraint = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size)
    
    self.view.addConstraint(constraint)
    if y % 2 == 0 || x % 2 == 0 {
    self.widthAndHeightConstraints.append(constraint)
    }
    constraint = NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size)
    
    self.view.addConstraint(constraint)
    if y % 2 == 0 || x % 2 == 0{
    self.widthAndHeightConstraints.append(constraint)
    }
    
    
    
    let xMultiplier = x / 24
    
    let yMultiplier = y / 24
    print (xMultiplier)
    
    self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: xMultiplier, constant: -size/2))
    
    self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: yMultiplier, constant: -size/2))
    
    view.alpha = 0
    view.delayedBounce(Double(Double(arc4random()) / Double(UINT32_MAX))*2)
    
    
    
    
    
    delay = delay + 0.004
    }
    x = x + 1
    }
    y = y + 1
    }
    
    /*
     
     self.repeater = LSRepeater.repeater(30.0 / Double(self.view.subviews.count), execute: {
     
     let view = self.view.subviews[self.viewIndex]
     
     self.viewIndex = self.viewIndex + 1
     
     view.smallBounce(40)
     
     UIView.animateWithDuration(0.1, animations: {
     view.alpha = 0
     })
     
     
     
     })
     */

    }
    
    
    func setProgress(pc: Double) {
        
        let count:Double = Double(self.view.subviews.count)
        
        var index:Double = 0
        
        for view in self.view.subviews.reverse() {
            
            if index / count > pc {
                
                if view.tag == 1 {
                view.tag = 0
              //  view.smallBounce(10)
         
                    UIView.animateWithDuration(2.0, animations: {
                        
                    view.alpha = 0
                    })
                }
            }
            else {
                UIView.animateWithDuration(2.0, animations: {
                
             //       view.smallBounce(10)
                    
                    view.alpha = 1.0
                    })
                    
                    view.tag = 1
            }
            
            index = index + 1
        }
        
        
    }
    

    
    func setAlternateRowSize(size:CGFloat) {
        for constraint in self.widthAndHeightConstraints {
            constraint.constant = size
        }
        
        UIView.animateWithDuration(1.0) { 
            self.view.layoutIfNeeded()
        }
        
    }

}
