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

  var repeater:LSRepeater!
  
  var viewIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
      
    //    self.view.backgroundColor = UIColor.greenColor()
      
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
      
      var delay:Double = 0.0
      
        var size:CGFloat = 6
      
      var y:CGFloat = 1
      
      for row in pixels {
        
        var x:CGFloat = 1
        
        for pixel in row {
          
          if pixel != 0 {
          
          let view = UIView(frame:CGRectZero)
            
          view.layer.cornerRadius = size / 2
            view.backgroundColor = pixel == 1 ? UIColor.redColor() : UIColor.greenColor()
            
            self.view.addSubview(view)
          
            view.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size))
            
            self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size))
            
            
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print(self.view.frame.size)

    }
    
    
    func resize() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
