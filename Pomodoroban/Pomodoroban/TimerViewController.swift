import UIKit
import CoreData
import DDTRepeater
import Firebase
import UserNotifications

protocol TimerViewControllerDelegate {
    func timerViewControllerEnded(_ timerViewController: TimerViewController)
    
}

class TimerViewController: UIViewController {
    
    var pixelVC: PixelTestViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.pixelVC = segue.destination as! PixelTestViewController
    }
    
    @IBOutlet weak var ticketBackgroundView: UIView!
    
    let storage = Storage.storage()
    
    var pomodoroLength:Double!
    var shortBreakLength:Double!
    var shortBreakCount:Int!
    var longBreakLength:Double!
    var haveALongBreak:Int!
    
    var index = 0
    var shortBreaks = 0
    
    @IBOutlet weak var takeABreakLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    var delegate:TimerViewControllerDelegate!
    
    let moc = CoreDataServices.sharedInstance.moc
    
    let darkBackgroundColor = UIColor(hexString: "555555")!
    let darkBackgroundColorForMask = UIColor(hexString: "505050")!
    
    let veryDarkBackgroundColor = UIColor(hexString: "333333")!
    let veryDarkBackgroundColorForMask = UIColor(hexString: "2e2e2e")!
    
    enum State {
        case short
        case long
        case ticket
        case none
    }
    
    func updateWithTicket(_ ticket: Ticket) {
        
        self.ticketBackgroundView.isHidden = false
        self.view.backgroundColor = self.veryDarkBackgroundColor
        self.timerLabel.textColor = UIColor.lightGray
        self.ticketBackgroundView.backgroundColor = UIColor.colorFrom(Int( ticket.colorIndex))
        self.titleLabel.text = ticket.name
        self.notesTextView.text = ticket.desc
        
        let pomodoroView = UIView.pomodoroRowWith(Int(ticket.pomodoroEstimate))
        self.pixelVC.setupAsPomodoro(self.pixelSizeForThisDevice())
    }
    
    
    func pixelSizeForThisDevice() -> CGFloat{
        let height = UIScreen.main.bounds.height
        if height == 568 {
            return 6
        }
        else if height >= 768 {
            return 20
        }
        return 10
    }
    
    func updateWithBreak() {
        self.timerLabel.textColor = UIColor.white
        self.ticketBackgroundView.isHidden = true
        self.view.backgroundColor = self.darkBackgroundColor
        
        self.pixelVC.setupAsCup(self.pixelSizeForThisDevice())
    }
    
    func updateWithLongBreak() {
        self.timerLabel.textColor = UIColor.white
        self.ticketBackgroundView.isHidden = true
        self.timerLabel.textColor = UIColor.lightGray
        
        self.view.backgroundColor = self.darkBackgroundColor
        
        self.pixelVC.setupAsFood(self.pixelSizeForThisDevice())
    }
    
    func close() {
        
        if let repeater = self.repeater {
            repeater.invalidate()
        }
        self.cancelNotificationsAndAudioPlaybacks()
        
        self.moveAllToNow()
        
        Runtime.removeAllEntities(self.moc)
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.removeObject(forKey: "startPausedDate")
        userDefaults.removeObject(forKey: "totalPausedTime")
        
        userDefaults.synchronize()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.hideTimer()
        
        self.delegate.timerViewControllerEnded(self)
        
    }
    
    var runtimes: [Runtime]!
    
    var startDate: Date!
    
    deinit {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.timerVC = nil
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func launch(section:String) {
        
        let defaults = UserDefaults.standard
        defaults.set(section, forKey: "section")
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.timerVC = self
        
        self.view.layer.cornerRadius = 20
        self.view.layer.borderWidth = 5
        self.view.layer.borderColor = UIColor.lightGray.cgColor
        self.view.clipsToBounds = true
        
        self.ticketBackgroundView.layer.cornerRadius = 10
        self.ticketBackgroundView.layer.borderWidth = 3
        self.ticketBackgroundView.layer.borderColor = UIColor.darkGray.cgColor
        self.ticketBackgroundView.clipsToBounds = true
        
        if Runtime.all(self.moc).count > 0 {
            self.startDate = UserDefaults.standard.object(forKey: "startDate") as! Date
        }
        else {
            
            let defaults = UserDefaults.standard
            
            self.startDate = Date()
            
            defaults.set(startDate, forKey: "startDate")
            defaults.synchronize()
            
            Runtime.removeAllEntities(self.moc)
            
            
            Runtime.createForSessionLength(section:section,self.moc,sessionLength:10000000, pomodoroLength: self.pomodoroLength, shortBreakLength: self.shortBreakLength, longBreakLength: self.longBreakLength, shortBreakCount: self.shortBreakCount, haveALongBreak:self.haveALongBreak)
            
            
            try! self.moc.save()
            
        }
        
        self.runtimes = Runtime.all(self.moc)
        
        
        self.registerCategory()
        
        
        UNUserNotificationCenter.current().delegate = self
        
        
        self.createNotifications()
        
        
        
        
        self.quitButton.layer.cornerRadius = 4
        self.quitButton.clipsToBounds = true
        self.quitButton.layer.borderColor = UIColor.white.cgColor
        self.quitButton.layer.borderWidth = 6
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        self.repeater = DDTRepeater.repeater(0.1, fireOnceInstantly: true, execute: {
            self.update()
        })
    }
    
    
    func registerCategory() -> Void{
        
        let callNow = UNNotificationAction(identifier: "call", title: "Call now", options: [])
        let clear = UNNotificationAction(identifier: "clear", title: "Clear", options: [])
        let category : UNNotificationCategory = UNNotificationCategory.init(identifier: "CALLINNOTIFICATION", actions: [callNow, clear], intentIdentifiers: [], options: [])
        
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([category])
        
    }
    
    var repeater:DDTRepeater!
    
    func startDatePlusPauses() -> Date {
        var startDatePlusPauses = self.startDate
        let userDefaults = UserDefaults.standard
        if let startPausedDate = userDefaults.object(forKey: "startPausedDate") as? Date{
            let diff = Date().timeIntervalSince(startPausedDate)
            startDatePlusPauses = startDatePlusPauses?.addingTimeInterval(diff)
        }
        if userDefaults.object(forKey: "totalPausedTime") != nil {
            let totalPausedTime = userDefaults.double(forKey: "totalPausedTime")
            startDatePlusPauses = startDatePlusPauses?.addingTimeInterval(TimeInterval(totalPausedTime))
        }
        
        return startDatePlusPauses!
        
    }
    
    var currentPartRemaining = 0.0
    var currentPartLength = 0.0
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    
    func moveAllToNow()
    {
        if let section = UserDefaults.standard.string(forKey: "section") {
            
            let defaults = UserDefaults.standard
            
            let createdFirstMotivationAlert = defaults.bool(forKey: "createdFirstMotivationAlert")
            
            if createdFirstMotivationAlert == false {
                
                defaults.set(true, forKey: "createdFirstMotivationAlert")
                defaults.synchronize()
           
                let alert = Alert.createInMoc(self.moc)
                
                alert.message = "Well done you completed your first session. Try and use Calchua each day to move forward on your most important tasks."
                alert.type = Alert.AlertType.AlertTypeFirstSessionCreated.rawValue
                    
                try! self.moc.save()
            }
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let dateString = formatter.string(from: Date())
            
            let startDatePlusPauses = self.startDatePlusPauses()
            
            let dateDiff = Date().timeIntervalSince(startDatePlusPauses)
            
            var runningTotal:TimeInterval = 0
            
            for runtime in self.runtimes {
                
                let runtimeLength = TimeInterval(runtime.length)
                
                runningTotal = runningTotal + runtimeLength
                
                
                if let ticket = Ticket.ticketForIdentifier(identifier: runtime.ticketIdentifier, moc: self.moc) {
                    
                    ticket.section = dateString + " " + section
                    
                }
            }
            try! self.moc.save()
        }
    }
    
    func update() {
        
        let startDatePlusPauses = self.startDatePlusPauses()
        
        let dateDiff = Date().timeIntervalSince(startDatePlusPauses)
        
        var runningTotal:TimeInterval = 0
        
        for runtime in self.runtimes {
            
            let runtimeLength = TimeInterval(runtime.length)
            
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
                    
                    if let ticket = Ticket.ticketForIdentifier(identifier: runtime.ticketIdentifier, moc: self.moc) {
                        
                        let partCount = ticket.pomodoroEstimate
                        self.timerLabel.text = String(format:"Seconds remaining = %.0f\nPomodoro in Story (%d/%d)",self.currentPartRemaining , part,partCount)
                        
                        self.updateWithTicket(ticket)
                    }
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
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            // ensure we only have one
            self.cancelNotificationsAndAudioPlaybacks()
            
            var runningTotal:Int32 = 0
            
            var index = 0
            
            let dateNow = Date()
            
            for runtime in self.runtimes {
                
                var message:String!
                var say:String!
                if runtime.type == 0 {
                    
                    if let ticket = Ticket.ticketForIdentifier(identifier: runtime.ticketIdentifier, moc: self.moc) {
                        
                        message = "It's time to start the '\(ticket.name!)' task"
                        say = message
                        
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
            
            self.createNotification(dateNow, date:self.startDatePlusPauses(), secondsFrom: Int(runningTotal)-1 ,message:"End Of Work, well done", index:index, say:"End Of Work, well done")
            
            
        }
    }
    
    var audioPlayer:AVAudioPlayer!
    
    func createNotification(_ dateNow:Date, date:Date, secondsFrom:Int, message: String, index: Int, say:String) {
        
        
        self.createAudioFromMessage(say,index:index)
        
        let fireDate = date.addingTimeInterval(TimeInterval(secondsFrom))
        var seconds = fireDate.timeIntervalSince(dateNow)
        
        
        if seconds > -1 && seconds <= 0 {
            seconds = 0.01
        }
        
        
        if seconds > 0 {
            
            
            
            let content = UNMutableNotificationContent()
            content.title = "Calchua"
            content.body = message
            content.sound = UNNotificationSound(named:"\(index).wav")
            content.categoryIdentifier = "dave"
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: seconds , repeats: false)
            let request = UNNotificationRequest.init(identifier: "\(index)", content: content, trigger: trigger)
            // Schedule the notification.
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
        }
        
        
    }
    
    func createAudioFromMessage(_ message:String, index:Int){
        
        let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        let soundsPath = libraryPath + "/Sounds"
        let filePath = soundsPath + "/\(index).wav"
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(atPath: soundsPath, withIntermediateDirectories: false, attributes: nil)
            
        } catch let error1 as NSError {
            print("error" + error1.description)
        }
        
        self.speechEngine.setVoice("cmu_us_slt")
        self.speechEngine.setPitch(194, variance:0, speed:1.0)
        self.speechEngine.writeMessage(message,toPath: filePath)
    }
    
    
    let speechEngine = FliteTTS()
    
    
    
    @IBAction func quitPressed(_ sender: AnyObject) {
        
        
        let alert = UIAlertController(title: "Menu", message: "", preferredStyle: .actionSheet)
        
        
        let userDefaults = UserDefaults.standard
        if let startPausedDate = userDefaults.object(forKey: "startPausedDate") as? Date {
            
            alert.addAction(UIAlertAction(title: "Unpause", style: .default, handler: { (action) in
                let userDefaults = UserDefaults.standard
                var totalPausedTime = 0.0
                if userDefaults.object(forKey: "totalPausedTime") != nil {
                    totalPausedTime = userDefaults.double(forKey: "totalPausedTime")
                }
                
                let timeDiff = Date().timeIntervalSince(startPausedDate)
                
                totalPausedTime = totalPausedTime + timeDiff
                
                userDefaults.removeObject(forKey: "startPausedDate")
                
                userDefaults.set(totalPausedTime, forKey: "totalPausedTime")
                
                userDefaults.synchronize()
                
                self.createNotifications()
            }))
        }
        else {
            
            alert.addAction(UIAlertAction(title: "Pause", style: .default, handler: { (action) in
                userDefaults.set(Date(), forKey: "startPausedDate" )
                
                userDefaults.synchronize()
                
                self.cancelNotificationsAndAudioPlaybacks()
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Skip this pomodoro", style: .default, handler: { (action) in
                
                var totalPausedTime = 0.0
                if userDefaults.object(forKey: "totalPausedTime") != nil {
                    totalPausedTime = userDefaults.double(forKey: "totalPausedTime")
                }
                totalPausedTime = totalPausedTime - self.currentPartRemaining
                
                userDefaults.set(totalPausedTime, forKey: "totalPausedTime")
                
                userDefaults.synchronize()
                
                self.cancelNotificationsAndAudioPlaybacks()
                self.createNotifications()
            }))
            
            alert.addAction(UIAlertAction(title: "back 5 mins", style: .default, handler: { (action) in
                
                var totalPausedTime = 0.0
                if userDefaults.object(forKey: "totalPausedTime") != nil {
                    totalPausedTime = userDefaults.double(forKey: "totalPausedTime")
                }
                totalPausedTime = totalPausedTime + 300
                
                userDefaults.set(totalPausedTime, forKey: "totalPausedTime")
                
                userDefaults.synchronize()
                self.cancelNotificationsAndAudioPlaybacks()
                
                self.createNotifications()
            }))
            
            alert.addAction(UIAlertAction(title: "forward 5 mins", style: .default, handler: { (action) in
                
                var totalPausedTime = 0.0
                if userDefaults.object(forKey: "totalPausedTime") != nil {
                    totalPausedTime = userDefaults.double(forKey: "totalPausedTime")
                }
                totalPausedTime = totalPausedTime - 300
                
                userDefaults.set(totalPausedTime, forKey: "totalPausedTime")
                
                userDefaults.synchronize()
                self.cancelNotificationsAndAudioPlaybacks()
                self.createNotifications()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Exit Current Pomodoro sequence", style: .default, handler: { (action) in
            self.close()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
        }))
        
        alert.popoverPresentationController?.sourceView = self.quitButton
        
        self.present(alert, animated: true, completion: nil)
    }
    
    var childMoc:NSManagedObjectContext!
    
    func saveChildMoc() {
        
        if self.childMoc != nil {
            self.moc.performAndWait({
                try! self.childMoc.save()
                self.childMoc = nil
                
                self.moc.performAndWait({
                    try! self.moc.save()
                })
            })
        }
    }
    
    func cancelNotificationsAndAudioPlaybacks() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

extension TimerViewController : TicketViewControllerDelegate {
    func ticketViewControllerSave(_ ticketViewController: TicketViewController) {
        self.dismiss(animated: true) {
            
            self.saveChildMoc()
        }
    }
    
    func delete(ticket:Ticket) {
        self.dismiss(animated: true) {
            
            
            
            
        }
    }
    
    func ticketViewControllerCancel(_ ticketViewController: TicketViewController) {
        self.dismiss(animated: true) {
        }
    }
}


extension TimerViewController : UNUserNotificationCenterDelegate {
    
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent")
        completionHandler([.sound])
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
