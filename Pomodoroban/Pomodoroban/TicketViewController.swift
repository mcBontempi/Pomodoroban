import UIKit

protocol TicketViewControllerDelegate {
    func ticketViewControllerSave(ticketViewController:TicketViewController)
    func ticketViewControllerCancel(ticketViewController:TicketViewController)
}


class TicketViewController: UITableViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var notes: UIView!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var pomodoroCountPicker: UIPickerView!
    
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    @IBOutlet weak var colorCircle: UIView!
    @IBAction func leftButtonPressed(sender: AnyObject) {
        self.delegate.ticketViewControllerCancel(self)
    }
    @IBAction func rightButtonPressed(sender: AnyObject) {
        self.save()
    }
    @IBOutlet weak var colorCell: UITableViewCell!
    @IBOutlet weak var notesText: UITextView!
    
    @IBOutlet weak var pomodoroCountView: UIView!
    var delegate: TicketViewControllerDelegate!
    var ticket:Ticket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        self.titleField.text = self.ticket.name
        
        
        self.notesText.text = self.ticket.desc
        
        
        self.navigationController?.navigationBar.translucent = false
        
        
     //   self.navigationController?.navigationBar.barTintColor = UIColor.colorFrom(Int( self.ticket.colorIndex))
        self.colorCircle.backgroundColor = UIColor.colorFrom(Int( self.ticket.colorIndex))
        
      //  self.colorCircle.layer.cornerRadius = 12.0
      //  self.colorCircle.layer.borderWidth = 1
      //  self.colorCircle.layer.borderColor = UIColor.blackColor().CGColor
        
        let pomodoroView = UIView.pomodoroRowWith(Int(self.ticket.pomodoroEstimate))
        self.pomodoroCountView.addSubview(pomodoroView)
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
    
    
    var colorHidden = true
    var pomodoroCountHidden = true
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.titleField.resignFirstResponder()
        self.notes.resignFirstResponder()
        
        if  indexPath.row == 1 {
            
            pomodoroCountHidden = true
            colorHidden = !colorHidden
            
            self.colorPicker.selectRow(Int(self.ticket.colorIndex), inComponent: 0, animated: true)
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        if indexPath.row == 3 {
            
            colorHidden = true
            
            pomodoroCountHidden = !pomodoroCountHidden
            
            self.pomodoroCountPicker.selectRow(Int(self.ticket.pomodoroEstimate)-1, inComponent: 0, animated: true)
            
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (self.pomodoroCountHidden && indexPath.row == 4) ||
            (self.colorHidden && indexPath.row == 2)
        {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension TicketViewController : UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
}


extension TicketViewController : UIPickerViewDelegate {
    
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        if pickerView == self.pomodoroCountPicker {
            
            let view = UIView.pomodoroRowWith(row+1)
            return view
        }
        else {
            let view = UIView()
            view.backgroundColor = UIColor.colorFrom(row)
            return view
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == self.colorPicker {
            
       //     self.navigationController?.navigationBar.barTintColor = UIColor.colorFrom(Int( row))
            self.colorCircle.backgroundColor = UIColor.colorFrom(row)
            
            
            self.ticket.colorIndex = Int32(row)
        }
        else {
            
            self.ticket.pomodoroEstimate = Int32(row+1)
            
            for view in self.pomodoroCountView.subviews {
                view.removeFromSuperview()
            }
            
            let pomodoroView = UIView.pomodoroRowWith(row+1)
            self.pomodoroCountView.addSubview(pomodoroView)
            
            
            
        }
    }
}

