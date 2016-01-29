//
//  PomodoroViewController.swift
//  Pomodoroban
//
//  Created by Daren taylor on 29/01/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit
import ALDClock

class PomodoroViewController: UIViewController {

  @IBOutlet weak var clock: ALDClock!
  
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

  clock.minuteHandColor = UIColor.redColor()
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
