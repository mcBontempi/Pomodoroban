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
      
      


      let size:CGFloat = 40.0
      let padding:CGFloat = 0.0
      
      
      let width = UIScreen.mainScreen().bounds.width
      
      let pomoSize = (size * 24) + (padding * 23)
      
      let leftPadding = (width - pomoSize) / 2
      
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
                    [0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0],
                    [0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0],
                    [0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0]]
      
      var delay:Double = 0.0
      
      
      var y:CGFloat = 100
      
      for row in pixels {
        
        var x:CGFloat = leftPadding
        
        for pixel in row {
          
          if pixel != 0 {
          
          let view = UIView(frame:CGRectMake(x,y,size,size))
          
          view.layer.cornerRadius = size / 2
            view.backgroundColor = pixel == 1 ? UIColor.redColor() : UIColor.greenColor()
            
            self.view.addSubview(view)
            
         //   view.delayedBounce(delay)
            
            delay = delay + 0.001
          }
          x = x + size + padding
        }
        y = y + size + padding
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
