//
//  TimerViewController.swift
//  Pomodoroban
//
//  Created by Daren David Taylor on 24/09/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit

protocol TimerViewControllerDelegate {
    func timerViewControllerDone(timerViewController: TimerViewController)
    func timerViewControllerQuit(timerViewController: TimerViewController)

}

class TimerViewController: UIViewController {
    
    var tickets:[Ticket]!
    var pomodoroLength:Int!
    var shortBreakLength:Int!
    var shortBreakCount:Int!
    var longBreakLength:Int!
    
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var timerLabel: MZTimerLabel!
    
    var delegate:TimerViewControllerDelegate!
    
    let moc = CoreDataServices.sharedInstance.moc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tickets = Ticket.allForToday(self.moc)
        
        self.timerLabel.timerType = MZTimerLabelTypeTimer
        timerLabel.setCountDownTime(Double(self.pomodoroLength) * 60)
        timerLabel.start()
        
        self.quitButton.layer.cornerRadius = 75
        self.quitButton.clipsToBounds = true
        self.quitButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.quitButton.layer.borderWidth = 6
        self.quitButton.layer.backgroundColor = UIColor.darkGrayColor().CGColor
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func quitPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
  //          self.delegate.timerViewControllerQuit(self)
        }
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
        
    //        self.delegate.timerViewControllerDone(self)
        
        }
    }
    
}
