import UIKit

protocol TicketViewControllerDelegate {
    func ticketViewControllerSave(_ ticketViewController:TicketViewController)
    func ticketViewControllerCancel(_ ticketViewController:TicketViewController)
    func delete(ticket:Ticket)
}

class TicketViewController: UITableViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var notes: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var sectionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    @IBOutlet weak var countSegmentedControl: UISegmentedControl!
    @IBOutlet weak var notesText: UITextView!
    
    var newTicket = false
    
    var setFocusToName = false
    var delegate: TicketViewControllerDelegate!
    var ticket:Ticket!
    
    @IBAction func leftButtonPressed(_ sender: AnyObject) {
        self.delegate.ticketViewControllerCancel(self)
    }
    @IBAction func rightButtonPressed(_ sender: AnyObject) {
        self.save()
    }
    
    @objc func countValueChanged(_ segmentedControl: UISegmentedControl) {
        self.ticket.pomodoroEstimate = Int32(segmentedControl.selectedSegmentIndex)+1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryCollectionView.dataSource = self
        
        self.tableView.tableFooterView = UIView()
        self.countSegmentedControl.addTarget(self, action: #selector(TicketViewController.countValueChanged(_:)), for: .valueChanged)
        self.countSegmentedControl.selectedSegmentIndex = Int(self.ticket.pomodoroEstimate) - 1
        self.titleField.text = self.ticket.name
        self.notesText.text = self.ticket.desc
        self.navigationController?.navigationBar.isTranslucent = false
        
        let indexPath = IndexPath(item: Int(self.ticket.colorIndex), section: 0)
        self.categoryCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        
        
        if let index =  ["Backlog","Morning","Afternoon","Evening"].index(of: self.ticket.section) {
            self.sectionSegmentedControl.selectedSegmentIndex = index
            self.sectionSegmentedControl.isHidden = false
            self.sectionLabel.isHidden = true
        }
        else {
            self.sectionSegmentedControl.isHidden = true
            self.sectionLabel.isHidden = false
            self.sectionLabel.text = self.ticket.section
        }
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
            self.ticket.colorIndex = Int32(self.categoryCollectionView.indexPathsForSelectedItems!.first!.row)
            self.delegate.ticketViewControllerSave(self)
            
            
            
            if let _ =  ["Backlog","Morning","Afternoon","Evening"].index(of: self.ticket.section) {
                let index = self.sectionSegmentedControl.selectedSegmentIndex
                
                self.ticket.section = ["Backlog","Morning","Afternoon","Evening"][index]
            }
            
            
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
        
        switch (indexPath.row) {
        case 0:
            self.titleField.becomeFirstResponder()
        case 3:
            self.notesText.becomeFirstResponder()
        case 5:
            self.delegate.delete(ticket:self.ticket)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 && self.newTicket == true {
            return 0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}

extension TicketViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UIColor.colorArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.colorArray()[indexPath.row]
        return cell
    }
}


