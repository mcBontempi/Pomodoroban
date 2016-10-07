//
//  TimerViewController.swift
//  Pomodoroban
//
//  Created by Daren David Taylor on 24/09/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit
import MZTimerLabel

protocol TimerViewControllerDelegate {
    func timerViewControllerDone(timerViewController: TimerViewController)
    func timerViewControllerQuit(timerViewController: TimerViewController)
    
}

class TimerViewController: UIViewController {
    
    @IBOutlet weak var ticketBackgroundView: UIView!
    var tickets:[Ticket]!
    var pomodoroLength:Int!
    var shortBreakLength:Int!
    var shortBreakCount:Int!
    var longBreakLength:Int!
    
    var index = 0
    var shortBreaks = 0
    
    @IBOutlet weak var takeABreakLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var timerLabel: MZTimerLabel!
    
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var pomodoroCountView: UIView!
    var delegate:TimerViewControllerDelegate!
    
    let moc = CoreDataServices.sharedInstance.moc
    
    
    func updateWithTicket(ticket: Ticket) {
        
        self.ticketBackgroundView.hidden = false
        self.view.backgroundColor = UIColor.blackColor()
        
        
        self.timerLabel.textColor = UIColor.whiteColor()
        
        
        self.ticketBackgroundView.backgroundColor = UIColor.colorFrom(Int( ticket.colorIndex))
        
        self.titleLabel.text = ticket.name
        
        self.notesTextView.text = ticket.desc
        
        for view in self.pomodoroCountView.subviews {
            view.removeFromSuperview()
        }
        
        let pomodoroView = UIView.pomodoroRowWith(Int(ticket.pomodoroEstimate))
        self.pomodoroCountView.addSubview(pomodoroView)
    }
    
    func updateWithBreak() {
        
        
        self.timerLabel.textColor = UIColor.blackColor()
        
        self.ticketBackgroundView.hidden = true
        
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    func startBreak() {
        self.updateWithBreak()
        
        self.timerLabel.timerType = MZTimerLabelTypeTimer
        
        if self.shortBreaks < self.shortBreakCount {
            
            self.takeABreakLabel.text = "Take a short break"
            
            timerLabel.setCountDownTime(Double(self.shortBreakLength) * 60)
            
            self.shortBreaks = self.shortBreaks + 1
        }
        else {
            
            self.takeABreakLabel.text = "Take a long break"
            
            timerLabel.setCountDownTime(Double(self.longBreakLength) * 60)
            
            self.shortBreaks = 0
        }
        
        if self.index == self.tickets.count - 1 {
            self.close()
        }
        else {
            timerLabel.startWithEndingBlock { (time) in
                
                self.tickets[self.index].pomodoroEstimate = self.tickets[self.index].pomodoroEstimate - 1
                
                if self.tickets[self.index].pomodoroEstimate == 0 {
                    
                    self.tickets[self.index].section = 8
                    
                    self.index = self.index + 1
                }
                
                try! self.moc.save()
                
                self.startWork()
            }
        }
    }
    
    func startWork() {
        self.updateWithTicket(self.tickets[index])
        
        self.timerLabel.timerType = MZTimerLabelTypeTimer
        timerLabel.setCountDownTime(Double(self.pomodoroLength) * 60)
        
        if self.index == self.tickets.count - 1 {
            self.close()
        }
        else {
            timerLabel.startWithEndingBlock { (time) in
                
                if self.index == self.tickets.count - 1  && self.tickets[self.index].pomodoroEstimate == 1 {
                    
                    self.close()
                    
                    
                    
                }
                
                
                self.startBreak()
            }
        }
    }
    
    func close() {
        self.timerLabel.endedBlock = nil
        
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tickets = Ticket.allForToday(self.moc)
        
        self.quitButton.layer.cornerRadius = 75
        self.quitButton.clipsToBounds = true
        self.quitButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.quitButton.layer.borderWidth = 6
        
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.createNotifications()
        
        
        
        self.startWork()
        
    }
    
    
    func createNotification(date:NSDate, minsFromNow:Int, message: String) {
        let notification = UILocalNotification()
        notification.alertBody = message
        notification.alertAction = "Do this now"
        notification.fireDate = date
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
    func createNotifications() {
     
        
        let date = NSDate().dateByAddingTimeInterval(1000)
        
        self.createNotification(date,minsFromNow:1,message:"hello")
        
        
    }
    
    
    
    @IBAction func quitPressed(sender: AnyObject) {
        
     //   self.timerLabel.pause()
        
        let alert = UIAlertController(title: "Paused", message: "", preferredStyle: .ActionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action) in
       //     self.timerLabel.reset()
        }))
        
        alert.addAction(UIAlertAction(title: "Quit", style: .Default, handler: { (action) in
            self.close()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
}
