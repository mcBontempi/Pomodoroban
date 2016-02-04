//
//  PomodoroViewController.swift
//  Pomodoroban
//
//  Created by Daren taylor on 29/01/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit
import BEMAnalogClock
import CoreData

class PomodoroViewController: UIViewController {
  
  @IBOutlet weak var textField: UITextField!
  
  var ticket:Ticket!
  let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
  
  @IBAction func closePressed(sender: AnyObject) {
    self.ticket.name = self.textField.text
    
    try! self.moc.save()
    
    self.dismissViewControllerAnimated(true) { () -> Void in
    }
  }
  
  
  var timer:NSTimer?
  var startInterval:NSTimeInterval?
  
  @IBOutlet weak var clock: BEMAnalogClockView!
  
  
  @IBOutlet weak var actionButton: UIButton!
  
  @IBAction func actionButtonPressed(sender: AnyObject) {
    self.actionButton.setTitle("Stop", forState: .Normal)
    
    self.startInterval = NSDate.timeIntervalSinceReferenceDate()
    
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = self.ticket.name
    self.textField.text = self.ticket.name
    
    self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("fire"), userInfo: nil, repeats: true)
    
    self.clock.stopRealTime()
    
    self.clock.hourHandAlpha = 0.0
    self.clock.minuteHandWidth = 8
    self.clock.secondHandWidth = 4
    self.clock.secondHandColor = UIColor.whiteColor()
    self.clock.minuteHandColor = UIColor.greenColor()
    self.clock.faceBackgroundColor = UIColor.redColor()
    
    self.clock.enableDigit = true
    self.clock.digitColor = UIColor.whiteColor()
    
    
    
    
    
    
    self.clock.minutes = 0
    self.clock.seconds = 0
    
    self.clock.updateTimeAnimated(true)
    
    
    
    
    self.actionButton.layer.cornerRadius = self.actionButton.frame.size.width/2
    self.actionButton.clipsToBounds = true
    
    self.actionButton.layer.borderColor = UIColor.whiteColor().CGColor
    self.actionButton.layer.borderWidth = 1
    
    if self.textField.text == "" {
      self.textField.becomeFirstResponder()
    }
  }
  
  func fire() {
    
    if let startInterval = self.startInterval {
      
      let timeIntervalNow = NSDate.timeIntervalSinceReferenceDate()
      
      self.clock.seconds = Int(timeIntervalNow - startInterval)
      
      self.clock.updateTimeAnimated(true)
    }
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


extension PomodoroViewController : UITextFieldDelegate
{
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
    let textFieldString = textField.text!
    
    let newString = (textFieldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
    
    
    self.title = newString
    
    self.ticket.name = newString
    try! self.moc.save()
    return true
  }
}

