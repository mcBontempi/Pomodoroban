import UIKit
import BEMAnalogClock
import CoreData

protocol PomodoroViewControllerDelegate {
    func pomodoroViewControllerDelegateSave(pomodoroViewController:PomodoroViewController)
    func pomodoroViewControllerDelegateCancal(pomodoroViewController:PomodoroViewController)
}

class PomodoroViewController: UIViewController {
    
    // vars
    
    var delegate: PomodoroViewControllerDelegate!
    var ticket:Ticket!
    var timer:NSTimer?
    var startInterval:NSTimeInterval?
    
    // outlets
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var clock: BEMAnalogClockView!
    @IBOutlet weak var actionButton: UIButton!
    
    // actions
    
    @IBAction func savePressed(sender: AnyObject) {
        self.save()
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.delegate.pomodoroViewControllerDelegateCancal(self)
    }
    
    @IBAction func actionButtonPressed(sender: AnyObject) {
        self.actionButton.setTitle("Stop", forState: .Normal)
        self.startInterval = NSDate.timeIntervalSinceReferenceDate()
    }
    
    // overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.text = self.ticket.name
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(PomodoroViewController.fire), userInfo: nil, repeats: true)
        
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
    
    // general
    
    func fire() {
        if let startInterval = self.startInterval {
            let timeIntervalNow = NSDate.timeIntervalSinceReferenceDate()
            self.clock.seconds = Int(timeIntervalNow - startInterval)
            self.clock.updateTimeAnimated(true)
        }
    }
    
    func save() {
        self.ticket.name = self.textField.text
        
        if self.textField.text != "" {
            self.delegate.pomodoroViewControllerDelegateSave(self)
        }
        else {
            let alert = UIAlertController(title: "Oops", message: "Please Enter a Name for the Ticket", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

// extensions

extension PomodoroViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.save()
        return true
    }
}

