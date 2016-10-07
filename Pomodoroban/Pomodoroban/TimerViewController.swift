//
//  TimerViewController.swift
//  Pomodoroban
//
//  Created by Daren David Taylor on 24/09/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit
import MZTimerLabel
import CoreData

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
            
            
                 self.createNotification(NSDate(),minsFromNow:self.shortBreakLength,message:"Its Time to Start Work, Tap to start.")
            
            self.shortBreaks = self.shortBreaks + 1
        }
        else {
            
            self.takeABreakLabel.text = "Take a long break"
            
            timerLabel.setCountDownTime(Double(self.longBreakLength) * 60)
            
              self.createNotification(NSDate(),minsFromNow:self.longBreakLength,message:"Its Time to Start Work, Tap to start.")
            
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
        
        
        self.createNotification(NSDate(),minsFromNow: 5 /*self.pomodoroLength*/,message:"Its Time For A Break, Tap to start.")
        
        
        
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
        self.startWork()
    }
    
    func createNotification(date:NSDate, minsFromNow:Int, message: String) {
        let notification = UILocalNotification()
        notification.alertBody = message
        notification.alertAction = "Hey there!"
        notification.fireDate = date.dateByAddingTimeInterval(NSTimeInterval(minsFromNow*60))
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    @IBAction func quitPressed(sender: AnyObject) {
    
        let alert = UIAlertController(title: "Menu", message: "", preferredStyle: .ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Quick Add", style: .Default, handler: { (action) in
        self.quickAdd()
        }))
        
        
        alert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { (action) in
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "Quit", style: .Default, handler: { (action) in
            self.close()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
 
    var childMoc:NSManagedObjectContext!
    
    func quickAdd() {
        let nc = self.storyboard?.instantiateViewControllerWithIdentifier("TicketNavigationViewController") as! UINavigationController
        let vc = nc.viewControllers[0] as! TicketViewController
        
        let row = Ticket.spareRowForSection(0, moc:self.moc)
        
        self.childMoc = CoreDataServices.sharedInstance.childMoc()
        vc.ticket = Ticket.createInMoc(self.childMoc)
        vc.ticket.name = ""
        vc.ticket.row = Int32(row)
        vc.ticket.section = Int32(0)
        vc.ticket.pomodoroEstimate = 1
        vc.ticket.colorIndex = 2
        
        vc.delegate = self
        
        self.presentViewController(nc, animated: true) {}
    }
    
    func saveChildMoc() {
        if self.childMoc != nil {
            self.moc.performBlockAndWait({
                try! self.childMoc.save()
                self.childMoc = nil
                
                self.moc.performBlockAndWait({
                    try! self.moc.save()
                })
            })
        }
    }
    
}



extension TimerViewController : TicketViewControllerDelegate {
    func ticketViewControllerSave(ticketViewController: TicketViewController) {
        self.dismissViewControllerAnimated(true) {
            self.saveChildMoc()
        }
    }
    
    func ticketViewControllerCancel(ticketViewController: TicketViewController) {
        self.dismissViewControllerAnimated(true) {
        }
    }
}

