import UIKit
import CoreData
import LSRepeater
import Firebase

protocol TimerViewControllerDelegate {
    func timerViewControllerDone(timerViewController: TimerViewController)
    func timerViewControllerQuit(timerViewController: TimerViewController)
}

class TimerViewController: UIViewController {
    
    
    var pixelVC: PixelTestViewController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.pixelVC = segue.destinationViewController as! PixelTestViewController
    }
    
    @IBOutlet weak var ticketBackgroundView: UIView!
    
    let storage = FIRStorage.storage()
    
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
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var pomodoroCountView: UIView!
    
    var delegate:TimerViewControllerDelegate!
    
    let moc = CoreDataServices.sharedInstance.moc
    
    let darkBackgroundColor = UIColor(hexString: "555555")!
    let darkBackgroundColorForMask = UIColor(hexString: "505050")!
    
    let veryDarkBackgroundColor = UIColor(hexString: "333333")!
    let veryDarkBackgroundColorForMask = UIColor(hexString: "2e2e2e")!
    
    func updateWithTicket(ticket: Ticket) {
        self.ticketBackgroundView.hidden = false
        self.view.backgroundColor = self.veryDarkBackgroundColor
        self.timerLabel.textColor = UIColor.lightGrayColor()
        self.ticketBackgroundView.backgroundColor = UIColor.colorFrom(Int( ticket.colorIndex))
        self.titleLabel.text = ticket.name
        self.notesTextView.text = ticket.desc
        for view in self.pomodoroCountView.subviews {
            view.removeFromSuperview()
        }
        let pomodoroView = UIView.pomodoroRowWith(Int(ticket.pomodoroEstimate))
        self.pomodoroCountView.addSubview(pomodoroView)
        
        let height = UIScreen.mainScreen().bounds.height
        if height == 568 {
            self.pixelVC.setupAsPomodoro(6)
        }
        else {
            self.pixelVC.setupAsPomodoro(10)
            
        }
    }
    
    func updateWithBreak() {
        self.timerLabel.textColor = UIColor.whiteColor()
        self.ticketBackgroundView.hidden = true
        self.view.backgroundColor = self.darkBackgroundColor
        
        
        self.pixelVC.setupAsCup(10)
    }
    
    func updateWithLongBreak() {
        self.timerLabel.textColor = UIColor.whiteColor()
        self.ticketBackgroundView.hidden = true
        self.timerLabel.textColor = UIColor.lightGrayColor()
        
        self.view.backgroundColor = self.darkBackgroundColor
        
        
        self.pixelVC.setupAsFood(10)
    }
    
    func close() {
        
        if let repeater = self.repeater {
            repeater.invalidate()
        }
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        Runtime.removeAllEntities(self.moc)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.removeObjectForKey("startPausedDate")
        userDefaults.removeObjectForKey("totalPausedTime")
        
        userDefaults.synchronize()
        
        self.dismissViewControllerAnimated(true) {
        }
    }
    
    var runtimes: [Runtime]!
    
    var startDate: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.layer.cornerRadius = 20
        self.view.layer.borderWidth = 5
        self.view.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.view.clipsToBounds = true
        
        
        
        self.ticketBackgroundView.layer.cornerRadius = 10
        self.ticketBackgroundView.layer.borderWidth = 3
        self.ticketBackgroundView.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.ticketBackgroundView.clipsToBounds = true
        
        if Runtime.all(self.moc).count > 0 {
            self.startDate = NSUserDefaults.standardUserDefaults().objectForKey("startDate") as! NSDate
        }
        else {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            self.startDate = NSDate()
            
            defaults.setObject(startDate, forKey: "startDate")
            defaults.synchronize()
            
            Runtime.removeAllEntities(self.moc)
            
            Runtime.createForToday(self.moc, pomodoroLength: self.pomodoroLength, shortBreakLength: self.shortBreakLength, longBreakLength: self.longBreakLength, shortBreakCount: self.shortBreakCount)
            
            
            try! self.moc.save()
            
            Runtime.printAll(self.moc)
            
        }
        
        self.runtimes = Runtime.all(self.moc)
        
        self.createNotifications()
        
        
        
        self.quitButton.layer.cornerRadius = 4
        self.quitButton.clipsToBounds = true
        self.quitButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.quitButton.layer.borderWidth = 6
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        self.repeater = LSRepeater.repeater(0.1, fireOnceInstantly: true, execute: {
            self.update()
        })
        
        
    }
    
    
    
    var repeater:LSRepeater!
    
    
    func startDatePlusPauses() -> NSDate {
        var startDatePlusPauses = self.startDate
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let startPausedDate = userDefaults.objectForKey("startPausedDate") as? NSDate{
            let diff = NSDate().timeIntervalSinceDate(startPausedDate)
            startDatePlusPauses = startDatePlusPauses.dateByAddingTimeInterval(diff)
        }
        if userDefaults.objectForKey("totalPausedTime") != nil {
            let totalPausedTime = userDefaults.doubleForKey("totalPausedTime")
            startDatePlusPauses = startDatePlusPauses.dateByAddingTimeInterval(NSTimeInterval(totalPausedTime))
        }
        
        return startDatePlusPauses
        
    }
    
    var currentPartRemaining = 0.0
    var currentPartLength = 0.0
    
    
    func getDocumentsDirectory() -> NSURL {
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func update() {
        
        let startDatePlusPauses = self.startDatePlusPauses()
        
        let dateDiff = NSDate().timeIntervalSinceDate(startDatePlusPauses)
        
        var runningTotal:NSTimeInterval = 0
        
        for runtime in self.runtimes {
            
            let runtimeLength = NSTimeInterval(runtime.length)
            
            runningTotal = runningTotal + runtimeLength
            
            if dateDiff < runningTotal {
                
                let part = runtime.part
                
                self.currentPartLength = Double(runtime.length)
                
                self.currentPartRemaining = runningTotal - dateDiff
                
                let pc = ( self.currentPartRemaining) / self.currentPartLength
                
            //    UIView.animateWithDuration(0.1, animations: {
                    
                    self.pixelVC.setProgress(pc)
              //  })
                
                if runtime.type == 0 {
                    
                    let ticket = runtime.ticket!
                    
                    let partCount = runtime.ticket.pomodoroEstimate
                    self.timerLabel.text = String(format:"Seconds remaining = %.0f\nPomodoro in Story (%d/%d)",self.currentPartRemaining , part,partCount)
                    
                    self.updateWithTicket(ticket)
                }
                else if runtime.type == 1 {
                    self.timerLabel.text = String(format:"Seconds remaining = %.0f", self.currentPartRemaining)
                    
                    self.takeABreakLabel.text = "Take a short break"
                    
                    self.updateWithBreak()
                }
                else if runtime.type == 2 {
                    self.timerLabel.text = String(format:"Seconds remaining = %.0f", self.currentPartRemaining)
                    
                    self.takeABreakLabel.text = "Take a long break"
                    
                    self.updateWithLongBreak()
                }
                
                //  self.upload()
                
                return
                
                //  self.updateWithTicket(runtime.ticket)
            }
            else {
                
            }
        }
        
        print("this is definately the end")
        self.close()
    }
    
    /*
     func upload() {
     let image =  self.view.image()
     
     if let data = UIImageJPEGRepresentation(image!,3) {
     
     let storageRef = storage.reference()
     
     let screenshotRef = storageRef.child("screenshot.jpg")
     
     let uploadTask = screenshotRef.putData(data, metadata: nil) { metadata, error in
     if let error = error {
     UIAlertController.quickMessage(error.description, vc:self)
     } else {
     print("uploaded")
     let downloadURL = metadata!.downloadURL()
     }
     }
     }
     }
     */
    
    func createNotifications() {
        
        // ensure we only have one
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        var runningTotal:Int32 = 0
        
        for runtime in self.runtimes {
            
            var message:String!
            if runtime.type == 0 {
                
                if let ticket = runtime.ticket {
                    
                    message = "It's time to start the '\(ticket.name!)' task"
                }
                else {
                    message = "Test Value"
                }
            }
            else if runtime.type == 1
            {
                message = "Take a short break for \(runtime.length/60) mins"
            }
            else if runtime.type == 2
            {
                message = "It's time for a long break of \(runtime.length/60) mins"
            }
            
            self.createNotification(self.startDatePlusPauses(), secondsFrom: Int(runningTotal) ,message:message)
            
            runningTotal = runningTotal + runtime.length
            
        }
    }
    
    func createNotification(date:NSDate, secondsFrom:Int, message: String) {
        
        print("mins from now \(secondsFrom) message\(message)")
        
        
        let notification = UILocalNotification()
        
        notification.alertBody = message
        notification.alertAction = "Hey there!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.fireDate = date.dateByAddingTimeInterval(NSTimeInterval(secondsFrom))
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
    @IBAction func quitPressed(sender: AnyObject) {
        
        
        let alert = UIAlertController(title: "Menu", message: "", preferredStyle: .ActionSheet)
        
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let startPausedDate = userDefaults.objectForKey("startPausedDate") as? NSDate {
            
            alert.addAction(UIAlertAction(title: "Unpause", style: .Default, handler: { (action) in
                let userDefaults = NSUserDefaults.standardUserDefaults()
                var totalPausedTime = 0.0
                if userDefaults.objectForKey("totalPausedTime") != nil {
                    totalPausedTime = userDefaults.doubleForKey("totalPausedTime")
                }
                
                let timeDiff = NSDate().timeIntervalSinceDate(startPausedDate)
                
                print(timeDiff)
                
                totalPausedTime = totalPausedTime + timeDiff
                
                userDefaults.removeObjectForKey("startPausedDate")
                
                userDefaults.setDouble(totalPausedTime, forKey: "totalPausedTime")
                
                userDefaults.synchronize()
                
                self.createNotifications()
            }))
        }
        else {
            
            alert.addAction(UIAlertAction(title: "Pause", style: .Default, handler: { (action) in
                userDefaults.setObject(NSDate(), forKey: "startPausedDate" )
                
                userDefaults.synchronize()
                
                UIApplication.sharedApplication().cancelAllLocalNotifications()
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Skip this pomodoro", style: .Default, handler: { (action) in
                
                var totalPausedTime = 0.0
                if userDefaults.objectForKey("totalPausedTime") != nil {
                    totalPausedTime = userDefaults.doubleForKey("totalPausedTime")
                }
                totalPausedTime = totalPausedTime - self.currentPartRemaining
                
                userDefaults.setDouble(totalPausedTime, forKey: "totalPausedTime")
                
                userDefaults.synchronize()
                
                UIApplication.sharedApplication().cancelAllLocalNotifications()
                self.createNotifications()
            }))
            
            alert.addAction(UIAlertAction(title: "back 5 mins", style: .Default, handler: { (action) in
                
                var totalPausedTime = 0.0
                if userDefaults.objectForKey("totalPausedTime") != nil {
                    totalPausedTime = userDefaults.doubleForKey("totalPausedTime")
                }
                totalPausedTime = totalPausedTime + 300
                
                userDefaults.setDouble(totalPausedTime, forKey: "totalPausedTime")
                
                userDefaults.synchronize()
                UIApplication.sharedApplication().cancelAllLocalNotifications()
                self.createNotifications()
                
                
            }))
            
            
            alert.addAction(UIAlertAction(title: "forward 5 mins", style: .Default, handler: { (action) in
                
                var totalPausedTime = 0.0
                if userDefaults.objectForKey("totalPausedTime") != nil {
                    totalPausedTime = userDefaults.doubleForKey("totalPausedTime")
                }
                totalPausedTime = totalPausedTime - 300
                
                userDefaults.setDouble(totalPausedTime, forKey: "totalPausedTime")
                
                userDefaults.synchronize()
                UIApplication.sharedApplication().cancelAllLocalNotifications()
                self.createNotifications()
                
                
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Quick Add Story to BACKLOG", style: .Default, handler: { (action) in
            self.quickAdd()
        }))
        
        alert.addAction(UIAlertAction(title: "Exit Current Pomodoro sequence", style: .Default, handler: { (action) in
            self.close()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
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

