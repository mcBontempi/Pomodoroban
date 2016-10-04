import UIKit
import CoreData

protocol PomodoroViewControllerDelegate {
    func pomodoroViewControllerDelegateSave(pomodoroViewController:PomodoroViewController)
    func pomodoroViewControllerDelegateCancal(pomodoroViewController:PomodoroViewController)
    func pomodoroViewControllerDelegateDone(pomodoroViewController:PomodoroViewController, ticket:Ticket)
}

class PomodoroViewController: UIViewController {
    
    // vars
    
    var delegate: PomodoroViewControllerDelegate!
    var ticket:Ticket!
    var startInterval:NSTimeInterval?
    
    // outlets
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    // actions
    
    @IBAction func savePressed(sender: AnyObject) {
        self.save()
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.delegate.pomodoroViewControllerDelegateCancal(self)
    }
    
    @IBAction func actionButtonPressed(sender: AnyObject) {
        self.startInterval = NSDate.timeIntervalSinceReferenceDate()
    }
    
    // overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.text = self.ticket.name

        
        if self.textField.text == "" {
            self.textField.becomeFirstResponder()
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

extension PomodoroViewController : TimerViewControllerDelegate {
    func timerViewControllerDone(timerViewController: TimerViewController) {
        self.delegate.pomodoroViewControllerDelegateDone(self, ticket:self.ticket)
    }
    
    func timerViewControllerQuit(timerViewController: TimerViewController) {
    }
}

