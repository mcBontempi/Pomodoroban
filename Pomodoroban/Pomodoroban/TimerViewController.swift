import UIKit
import CoreData
import LSRepeater
import Firebase
import UserNotifications

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
    
    var pomodoroLength:Double!
    var shortBreakLength:Double!
    var shortBreakCount:Int!
    var longBreakLength:Double!
    
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
    
    
    
    enum State {
        case Short
        case Long
        case Ticket
        case None
    }
    
    
    //  var state:State = .None
    
    
    
    
    
    
    func updateWithTicket(ticket: Ticket) {
        
        // if (self.state != )
        
        
        // self.state = Ticket
        
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
        self.cancelNotificationsAndAudioPlaybacks()
        
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
    
    deinit {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.timerVC = nil
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.timerVC = self
        
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
            
        }
        
        self.runtimes = Runtime.all(self.moc)
        
        
        self.registerCategory()
        
        
        UNUserNotificationCenter.currentNotificationCenter().delegate = self
        
        
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
    
    
    func registerCategory() -> Void{
        
        let callNow = UNNotificationAction(identifier: "call", title: "Call now", options: [])
        let clear = UNNotificationAction(identifier: "clear", title: "Clear", options: [])
        let category : UNNotificationCategory = UNNotificationCategory.init(identifier: "CALLINNOTIFICATION", actions: [callNow, clear], intentIdentifiers: [], options: [])
        
        let center = UNUserNotificationCenter.currentNotificationCenter()
        center.setNotificationCategories([category])
        
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
                return
            }
            else {
                
            }
        }
        
        print("this is definately the end")
        self.close()
    }
    
    func createNotifications() {
        //  let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        //  dispatch_async(dispatch_get_global_queue(priority, 0)) {
        // ensure we only have one
        self.cancelNotificationsAndAudioPlaybacks()
        
        var runningTotal:Int32 = 0
        
        var index = 0
        
        let dateNow = NSDate()
        
        for runtime in self.runtimes {
            
            var message:String!
            var say:String!
            if runtime.type == 0 {
                
                if let ticket = runtime.ticket {
                    
                    message = "It's time to start the '\(ticket.name!)' task"
                    say = ticket.name!
                    
                }
                else {
                    message = "Test Value"
                    say = "Test Vlaue"
                }
            }
            else if runtime.type == 1
            {
                message = "Take a short break for \(runtime.length/60) minutes"
                say = message
            }
            else if runtime.type == 2
            {
                message = "It's time for a long break of \(runtime.length/60) minutes"
                say = message
            }
            
            self.createNotification(dateNow, date:self.startDatePlusPauses(), secondsFrom: Int(runningTotal) ,message:message, index:index, say:say)
            
            index = index + 1
            runningTotal = runningTotal + runtime.length
        }
        //   }
    }
    
    var audioPlayer:AVAudioPlayer!
    
    func createNotification(dateNow:NSDate, date:NSDate, secondsFrom:Int, message: String, index: Int, say:String) {
        
        let fireDate = date.dateByAddingTimeInterval(NSTimeInterval(secondsFrom))
        let seconds = fireDate.timeIntervalSinceDate(dateNow)
        
        if seconds > 0 {
            let content = UNMutableNotificationContent()
            content.title = "POMODOROBAN"
            content.body = message
            content.sound = UNNotificationSound(named:"\(index).wav")
            content.categoryIdentifier = "dave"
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: seconds , repeats: false)
            let request = UNNotificationRequest.init(identifier: "\(index)", content: content, trigger: trigger)
            // Schedule the notification.
            let center = UNUserNotificationCenter.currentNotificationCenter()
            center.addNotificationRequest(request, withCompletionHandler: nil)
        }
    }
    
    func createAudioFromMessage(message:String, index:Int){
        
        let libraryPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        let soundsPath = libraryPath + "/Sounds"
        let filePath = soundsPath + "/\(index).wav"
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.createDirectoryAtPath(soundsPath, withIntermediateDirectories: false, attributes: nil)
            
        } catch let error1 as NSError {
            print("error" + error1.description)
        }
        
        self.speechEngine.setVoice("cmu_us_slt")
        self.speechEngine.setPitch(194, variance:0, speed:1.0)
        self.speechEngine.writeMessage(message,toPath: filePath)
    }
    
    
    let speechEngine = FliteTTS()
    
    
    
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
                
                self.cancelNotificationsAndAudioPlaybacks()
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Skip this pomodoro", style: .Default, handler: { (action) in
                
                var totalPausedTime = 0.0
                if userDefaults.objectForKey("totalPausedTime") != nil {
                    totalPausedTime = userDefaults.doubleForKey("totalPausedTime")
                }
                totalPausedTime = totalPausedTime - self.currentPartRemaining
                
                userDefaults.setDouble(totalPausedTime, forKey: "totalPausedTime")
                
                userDefaults.synchronize()
                
                self.cancelNotificationsAndAudioPlaybacks()
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
                self.cancelNotificationsAndAudioPlaybacks()
                
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
                self.cancelNotificationsAndAudioPlaybacks()
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
    
    func cancelNotificationsAndAudioPlaybacks() {
        UNUserNotificationCenter.currentNotificationCenter().removeAllDeliveredNotifications()
        UNUserNotificationCenter.currentNotificationCenter().removeAllPendingNotificationRequests()
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


extension TimerViewController : UNUserNotificationCenterDelegate {
    
    
    
    
    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        
        print("willPresent")
        completionHandler([.Sound])
    }
    
    /*
     func userNotificationCenter(center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: () -> Void) {
     
     let path = notification.request.content.sound
     
     let url = NSURL(fileURLWithPath: path!.description)
     print("say speech")
     print(url)
     self.audioPlayer = try! AVAudioPlayer(contentsOfURL: url)
     self.audioPlayer.play()
     
     }
     */
    
}

