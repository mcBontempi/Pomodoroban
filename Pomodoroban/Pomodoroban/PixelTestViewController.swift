//
//  PixelTestViewController.swift
//  Pomodoroban
//
//  Created by Daren taylor on 20/10/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit

class PixelTestViewController: UIViewController {
    
    enum Mode {
        case none
        case pomodoro
        case cup
        case food
    }
    
    
    var mode:Mode = .none
    
    var widthAndHeightConstraints = [NSLayoutConstraint]()
    
    var viewIndex = 0
    
    func setupAsCup(_ size:CGFloat, small:Bool = false) {
        
        
        if mode != .cup {
            self.mode = .cup
            self.removeAll()
            
            // cup outline = 8
            // tea = 9
            // cup & plate outline = 10
            // choc chip = 11
            // plate = 12
            
            
            let pixels = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                          [0,0,0,0,0,0,0,0,8,8,8,8,8,8,8,8,8,0,0,0,0,0,0,0],
                          [0,0,0,0,0,0,8,8,8,9,9,9,9,9,9,9,8,8,8,0,0,0,0,0],
                          [0,0,0,0,0,8,9,9,9,9,9,9,9,9,9,9,9,9,9,8,0,0,0,0],
                          [0,0,0,0,0,8,9,9,9,9,9,9,9,9,9,9,9,9,9,8,0,0,0,0],
                          [0,0,0,0,0,8,9,9,9,9,9,9,9,9,9,9,9,9,9,8,8,8,0,0],
                          [0,0,0,0,0,8,8,8,8,8,8,9,9,9,8,8,8,8,8,8,8,8,8,0],
                          [0,0,0,0,0,8,10,10,10,10,8,8,8,8,8,10,10,10,10,8,0,0,8,8],
                          [0,0,0,0,0,8,10,10,10,10,10,10,10,10,10,10,10,10,10,8,0,0,0,8],
                          [0,0,0,0,0,8,10,10,10,10,10,10,10,10,10,10,10,10,10,8,0,0,0,8],
                          [0,0,0,0,0,8,10,10,10,10,10,10,10,10,10,10,10,10,10,8,0,0,8,8],
                          [0,0,0,0,0,8,10,10,10,10,10,10,10,10,10,10,10,10,10,8,0,8,8,0],
                          [0,0,9,11,10,8,10,10,10,10,10,10,10,10,10,10,10,10,10,8,8,8,0,0],
                          [0,0,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,8,8,12,10,0],
                          [11,9,11,9,11,9,8,10,10,10,10,10,10,10,10,10,10,10,8,12,12,12,12,10],
                          [9,11,9,9,9,9,9,8,8,10,10,10,10,10,10,10,8,8,12,12,12,12,12,10],
                          [0,9,9,11,9,11,12,12,9,9,8,8,8,8,8,8,12,12,12,12,12,12,12,10],
                          [0,10,10,9,9,12,9,11,9,9,11,9,12,12,12,12,12,12,12,12,12,12,10,0],
                          [0,0,0,10,12,9,9,9,11,9,9,9,12,12,12,12,12,12,12,12,12,10,10,0,0],
                          [0,0,0,0,10,11,9,11,9,9,11,9,12,12,12,12,12,12,10,10,10,0,0,0,0],
                          [0,0,0,0,0,0,9,9,9,11,9,10,10,10,10,10,10,10,0,0,0,0,0,0,0],
                          [0,0,0,0,0,0,0,11,9,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                          [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]
            
            self.setupWithPixels(pixels, size:size , small:small)
            
        }
        
    }
    
    func setupAsFood(_ size:CGFloat, small:Bool = false) {
        
        if self.mode != .food {
            self.mode = .food
            self.removeAll()
            
            
            // 0 = black
            // 3 = bap
            // 4 = red
            // 5 = green
            // 6 = brown
            // 7 = cheese
            
            
            let pixels = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                          [0,0,0,0,0,0,0,0,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,0],
                [0,0,0,0,0,0,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0],
                [0,0,0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0],
                [0,0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0],
                [0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0],
                [0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0],
                [0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0],
                [0,0,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,0,0],
                [0,0,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,0],
                [4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5],
                [4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,6,5,6,5,5,5,5],
                [4,4,4,4,7,5,5,5,5,5,5,5,5,5,5,6,5,6,5,6,6,5,6,0],
                [4,4,6,6,7,7,5,5,5,5,7,7,5,6,5,6,6,6,6,6,6,6,6,0],
                [0,6,6,6,6,7,5,7,7,7,7,6,6,6,6,6,6,6,6,6,6,6,6,0],
                [0,6,6,6,6,7,7,7,7,7,7,6,6,6,6,6,6,6,6,6,6,6,0,0],
                [0,6,6,6,6,6,7,7,7,7,6,6,6,6,6,6,6,6,3,3,3,3,0,0],
                [0,0,6,6,6,6,7,7,7,6,6,6,3,3,3,3,3,3,3,3,3,3,0,0],
                [0,0,3,3,3,3,3,7,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0],
                [0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0],
                [0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0],
             
                [0,0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0],
                [0,0,0,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,0,0,0],
                [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]
            
            self.setupWithPixels(pixels,size:size, small:small)
            
        }
    }
    
    func removeAll() {
        self.widthAndHeightConstraints.removeAll()
        
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
    }
    
    
    func setupAsPomodoro(_ size:CGFloat, small:Bool = false) {
        
        if self.mode != .pomodoro {
            
            self.mode = .pomodoro
            
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
            
            self.setupWithPixels(pixels, size:size, small:small)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
    }
    
    func setupWithPixels(_ pixels:[[Int]], size:CGFloat, small:Bool) {
        
        var delay:Double = 0.0
        
        var y:CGFloat = 1
        
        for row in pixels {
            
            var x:CGFloat = 1
            
            for pixel in row {
                
                if pixel != 0 {
                    
                    let view = UIView(frame:CGRect.zero)
                    view.tag = 1
                    view.layer.cornerRadius = size / 2
                    
                    
                    
                    
                    
                    view.backgroundColor = [UIColor.gray,UIColor.red,UIColor.green, UIColor(hexString:"d9a427"),UIColor(hexString:"d20915"), UIColor(hexString:"48a81c"), UIColor(hexString:"542205"), UIColor(hexString:"fedc61"),
                        
                        UIColor(hexString:"c3b1d2"),
                        UIColor(hexString:"ce8230"),
                        UIColor(hexString:"e3dcec"),
                        UIColor(hexString:"3f1500"),
                        UIColor(hexString:"7b7684")
                      
                        
                        
                        
                        ][pixel]
                    
                    self.view.addSubview(view)
                    
                    view.translatesAutoresizingMaskIntoConstraints = false
                    
                    
                    var constraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size)
                    
                    self.view.addConstraint(constraint)
                    if y.truncatingRemainder(dividingBy: 2) == 0 || x.truncatingRemainder(dividingBy: 2) == 0 {
                        self.widthAndHeightConstraints.append(constraint)
                    }
                    constraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: size)
                    
                    self.view.addConstraint(constraint)
                    if y.truncatingRemainder(dividingBy: 2) == 0 || x.truncatingRemainder(dividingBy: 2) == 0{
                        self.widthAndHeightConstraints.append(constraint)
                    }
                    
                    
                    
                    let xMultiplier = x / 24
                    
                    let yMultiplier = y / 24
                    
                    self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: xMultiplier, constant: -size/2))
                    
                    self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: yMultiplier, constant: -size/2))
                    
                    view.alpha = 0
                    view.delayedBounce(Double(Double(arc4random()) / Double(UINT32_MAX))*2)
                    
                    
                    
                    
                    
                    delay = delay + 0.004
                }
                x = x + 1
            }
            y = y + 1
        }
        
        if small == true {
            self.setAlternateRowSize(0, animate:false)
        }
        
    }
    
    
    func setProgress(_ pc: Double) {
        
        let count:Double = Double(self.view.subviews.count)
        
        var index:Double = 0
        
        for view in self.view.subviews.reversed() {
            
            if index / count > pc {
                
                if view.tag == 1 {
                    view.tag = 0
                    //  view.smallBounce(10)
                    
                    UIView.animate(withDuration: 2.0, animations: {
                        
                        view.alpha = 0
                    })
                }
            }
            else {
                UIView.animate(withDuration: 2.0, animations: {
                    
                    //       view.smallBounce(10)
                    
                    view.alpha = 1.0
                })
                
                view.tag = 1
            }
            
            index = index + 1
        }
        
        
    }
    
    
    
    func setAlternateRowSize(_ size:CGFloat, animate:Bool = true) {
        
        for constraint in self.widthAndHeightConstraints {
            constraint.constant = size
        }
        if animate == true {
        UIView.animate(withDuration: 1.0, animations: { 
            self.view.layoutIfNeeded()
        })
        }
        
    }
    
}
