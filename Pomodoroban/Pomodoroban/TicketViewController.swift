import UIKit

protocol TicketViewControllerDelegate {
    func ticketViewControllerSave(ticketViewController:TicketViewController)
    func ticketViewControllerCancel(ticketViewController:TicketViewController)
}


class TicketViewController: UITableViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var notes: UIView!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    @IBOutlet weak var headerColor: UIView!
    
    @IBOutlet weak var countSegmentedControl: UISegmentedControl!
    @IBAction func leftButtonPressed(sender: AnyObject) {
        self.delegate.ticketViewControllerCancel(self)
    }
    @IBAction func rightButtonPressed(sender: AnyObject) {
        self.save()
    }
    @IBOutlet weak var notesText: UITextView!
    
    var delegate: TicketViewControllerDelegate!
    var ticket:Ticket!
    
    func customiseCategorySegmentedControl() {
        
        var index = 0
        
        let colors = UIColor.colorArray().reverse()
        for color in colors {
            let view = self.categorySegmentedControl.subviews[index]
            
            index = index + 1
            
            view.backgroundColor = color
        }
    }
    
    
    func categoryValueChanged(segmentedControl: UISegmentedControl) {
        
        self.ticket.colorIndex = Int32(segmentedControl.selectedSegmentIndex)
        
        self.headerColor.backgroundColor = UIColor.colorFrom(Int( self.ticket.colorIndex))
        
    }
    
    func countValueChanged(segmentedControl: UISegmentedControl) {
        self.ticket.pomodoroEstimate = Int32(segmentedControl.selectedSegmentIndex)+1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        
        self.categorySegmentedControl.addTarget(self, action: #selector(TicketViewController.categoryValueChanged(_:)), forControlEvents: .ValueChanged)
        
        self.countSegmentedControl.addTarget(self, action: #selector(TicketViewController.countValueChanged(_:)), forControlEvents: .ValueChanged)
        
        
        self.categorySegmentedControl.selectedSegmentIndex = Int(self.ticket.colorIndex)
        self.countSegmentedControl.selectedSegmentIndex = Int(self.ticket.pomodoroEstimate) - 1
        
        
        
        self.customiseCategorySegmentedControl()
        
        self.titleField.text = self.ticket.name
        
        
        self.notesText.text = self.ticket.desc
        
        
        self.navigationController?.navigationBar.translucent = false
        
        self.headerColor.backgroundColor = UIColor.colorFrom(Int( self.ticket.colorIndex))
        
        //    let pomodoroView = UIView.pomodoroRowWith(Int(self.ticket.pomodoroEstimate))
        
        
        
    }
    
    func save() {
        
        if self.titleField.text != "" {
            
            self.ticket.desc = self.notesText.text
            self.ticket.name = self.titleField.text
            self.delegate.ticketViewControllerSave(self)
        }
        else {
            let alert = UIAlertController(title: "Oops", message: "Please Enter a Name for the Ticket", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.titleField.resignFirstResponder()
        self.notes.resignFirstResponder()
        
        if indexPath.row == 0 {
            self.titleField.becomeFirstResponder()
        }
            
        else if indexPath.row == 3 {
            self.notesText.becomeFirstResponder()
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}



