import UIKit

protocol TicketViewControllerDelegate {
    func ticketViewControllerSave(_ ticketViewController:TicketViewController)
    func ticketViewControllerCancel(_ ticketViewController:TicketViewController)
}


class TicketViewController: UITableViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var notes: UIView!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var sectionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    @IBOutlet weak var headerColor: UIView!
    
    @IBOutlet weak var countSegmentedControl: UISegmentedControl!
    @IBAction func leftButtonPressed(_ sender: AnyObject) {
        self.delegate.ticketViewControllerCancel(self)
    }
    @IBAction func rightButtonPressed(_ sender: AnyObject) {
        self.save()
    }
    @IBOutlet weak var notesText: UITextView!
    
    var setFocusToName = false
    
    var delegate: TicketViewControllerDelegate!
    var ticket:Ticket!
    
    func customiseCategorySegmentedControl() {
        
        var index = 0
        
        let colors = UIColor.colorArray().reversed()
        for color in colors {
            
            print(color)
            
            let view = self.categorySegmentedControl.subviews[index]
            
            index = index + 1
            
            view.backgroundColor = color
        }
    }
    
    
    @objc func categoryValueChanged(_ segmentedControl: UISegmentedControl) {
        
        
        self.headerColor.backgroundColor = UIColor.colorFrom(Int( segmentedControl.selectedSegmentIndex))
        
    }
    
    @objc func countValueChanged(_ segmentedControl: UISegmentedControl) {
        self.ticket.pomodoroEstimate = Int32(segmentedControl.selectedSegmentIndex)+1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customiseCategorySegmentedControl()
        
        
        self.tableView.tableFooterView = UIView()
        
        
        self.categorySegmentedControl.addTarget(self, action: #selector(TicketViewController.categoryValueChanged(_:)), for: .valueChanged)
        
        self.countSegmentedControl.addTarget(self, action: #selector(TicketViewController.countValueChanged(_:)), for: .valueChanged)
        
        
        self.categorySegmentedControl.selectedSegmentIndex = Int(self.ticket.colorIndex)
        self.countSegmentedControl.selectedSegmentIndex = Int(self.ticket.pomodoroEstimate) - 1
        
        
        
        self.sectionSegmentedControl.selectedSegmentIndex = Int(self.ticket.section)
        
        
        
        self.titleField.text = self.ticket.name
        
        
        self.notesText.text = self.ticket.desc
        
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.headerColor.backgroundColor = UIColor.colorFrom(Int( self.ticket.colorIndex))
        
        //    let pomodoroView = UIView.pomodoroRowWith(Int(self.ticket.pomodoroEstimate))
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        /*
         let tracker = GAI.sharedInstance().defaultTracker
         tracker.set(kGAIScreenName, value: "Story Editor")
         
         let builder = GAIDictionaryBuilder.createScreenView()
         tracker.send(builder.build() as [NSObject : AnyObject])
         */
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.setFocusToName == true {
            self.titleField.becomeFirstResponder()
            self.setFocusToName = false
        }
    }
    
    func save() {
        
        if self.titleField.text != "" {
            
            self.ticket.desc = self.notesText.text
            self.ticket.name = self.titleField.text
            
            self.ticket.colorIndex = Int32(self.categorySegmentedControl.selectedSegmentIndex)
            self.ticket.section = Int32(self.sectionSegmentedControl.selectedSegmentIndex)
            self.delegate.ticketViewControllerSave(self)
        }
        else {
            let alert = UIAlertController(title: "Oops", message: "Please Enter a Name for the Ticket", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.titleField.resignFirstResponder()
        self.notes.resignFirstResponder()
        
        if indexPath.row == 0 {
            self.titleField.becomeFirstResponder()
        }
            
        else if indexPath.row == 3 {
            self.notesText.becomeFirstResponder()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

