import UIKit
import CoreData
import Onboard
import Firebase
import FirebaseDatabase
import FirebaseAuth
import UserNotifications
import MBProgressHUD
//import EasyTipView

class BoardTableViewController: UIViewController {
    var selectedIdentifiers = [String]() {
        didSet {
            
            self.buttonsEnabled = selectedIdentifiers.count > 0
            self.collectionView.isUserInteractionEnabled = buttonsEnabled
            self.collectionView.reloadData()
        }
    }
    
    var buttonsEnabled = false
    
    @IBOutlet weak var movePanelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    let moc = CoreDataServices.sharedInstance.moc
    
    var childMoc:NSManagedObjectContext!
    
    var section:String!
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let tempFetchedResultsController = NSFetchedResultsController( fetchRequest: Ticket.fetchRequestForSection(self.section), managedObjectContext: self.moc, sectionNameKeyPath: "section", cacheName: nil)
        tempFetchedResultsController.delegate = self
        return tempFetchedResultsController
    }()
    
    @IBAction func addPressed(_ sender: AnyObject) {
        self.addInSection(self.section)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func editMode() -> Bool {
        return ["Morning","Afternoon","Evening"].contains(self.section)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.editMode(){
            self.movePanelHeightConstraint.constant = 0
            self.tableView.setEditing(true, animated: true)
        }
        
        self.collectionView.delegate = self
        
        self.collectionView.dataSource = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "productsRefreshed"), object: nil, queue: nil) { (Notification) in
        }
        
        try! self.fetchedResultsController.performFetch()
        self.tableView.allowsSelectionDuringEditing = true
        self.tableView.tableFooterView = UIView()
        self.navigationController!.redWithLogo()
        self.tableView.tableHeaderView = nil
        self.title = section.components(separatedBy: " ").count < 2 ? section :  section.components(separatedBy: " ")[0] + " " + section.components(separatedBy: " ")[1]
        
        self.playButton.isHidden = !FeedTableViewController.sections().contains(self.section) || self.section == "Backlog"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    func showLogin(_ register:Bool) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        if register == true {
            
            vc.mode = .signupOnly
        }
        else {
            vc.mode = .login
        }
        
        self.present(vc, animated: false, completion: {
        })
        
    }
    
    func addInSection(_ section:String) {
        let nc = self.storyboard?.instantiateViewController(withIdentifier: "TicketNavigationViewController") as! UINavigationController
        let vc = nc.viewControllers[0] as! TicketViewController
        
        vc.setFocusToName = true
        
        let row = Ticket.spareRowForSection(section, moc:self.moc)
        
        self.childMoc = CoreDataServices.sharedInstance.childMoc()
        vc.ticket = Ticket.createInMoc(self.childMoc)
        vc.ticket.name = ""
        vc.ticket.row = Int32(row)
        vc.ticket.section = section
        vc.ticket.pomodoroEstimate = 1
        vc.ticket.colorIndex = 2
        
        vc.delegate = self
        
        self.present(nc, animated: true) {}
        
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "timerSegue" {
            let nc = segue.destination as! UINavigationController
            let vc = nc.viewControllers.first as! NaturalLanguageViewController
            vc.section = self.section
            return
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "timerSegue" {
            if Ticket.allForSection(self.moc, section: self.section).count < 1 {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                
                let alert = UIAlertController(title: "Oops", message: "There need to be some Stories in \(self.section) for this to work!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                return false
            }
                
            else {
                return true
            }
        }
        return true
    }
    
}

extension BoardTableViewController : TicketViewControllerDelegate {
    func ticketViewControllerSave(_ ticketViewController: TicketViewController) {
        
        self.dismiss(animated: true) {
            self.saveChildMoc()
        }
    }
    
    func delete(ticket:Ticket) {
        self.dismiss(animated: true) {
            ticket.removed = true
            
            
            self.saveChildMoc()
        }
    }
    
    func ticketViewControllerCancel(_ ticketViewController: TicketViewController) {
        
        self.dismiss(animated: true) {
        }
    }
}

extension BoardTableViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

extension BoardTableViewController : SectionSelectTableViewControllerDelegate
{
    func sectionSelectTableViewControllerCancelled(sectionSelectTableViewController: SectionSelectTableViewController) {
        self.dismiss(animated: true) {}
    }
    
    func sectionSelectTableViewController(sectionSelectTableViewController: SectionSelectTableViewController, didSelectTitles: [String]) {
        
        let defaults = UserDefaults.standard
        
        defaults.setValue(didSelectTitles, forKey: "selectedSectionTitles")
        defaults.synchronize()
        self.dismiss(animated: true) {self.tableView.reloadData()}
    }
    
}



extension BoardTableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nc = self.storyboard?.instantiateViewController(withIdentifier: "TicketNavigationViewController") as! UINavigationController
        let vc = nc.viewControllers[0] as! TicketViewController
        
        self.childMoc = CoreDataServices.sharedInstance.childMoc()
        vc.ticket = Ticket.ticketForTicket(self.fetchedResultsController.object(at: indexPath) as! Ticket, moc:self.childMoc)
        
        vc.delegate = self
        
        self.present(nc, animated: true) {}
    }
}

extension BoardTableViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if let sections = self.fetchedResultsController.sections {
            if sections.count == 0 {
                return 0
            }
            
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let ticket = fetchedResultsController.object(at: sourceIndexPath) as? Ticket
        Ticket.insertTicket(ticket!, row: destinationIndexPath.row,section:self.section, moc:self.moc)
        
        try! self.moc.save()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let ticket = fetchedResultsController.object(at: indexPath) as? Ticket {
                
                ticket.removed = true
                
                self.saveChildMoc()
            }
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let sections = self.fetchedResultsController.sections {
            let currentSection = sections[indexPath.section]
            if indexPath.row < currentSection.numberOfObjects {
                
                
                let ticket = fetchedResultsController.object(at: indexPath) as? Ticket
                let cell = tableView.dequeueReusableCell(withIdentifier: "TicketTableViewCell") as! TicketTableViewCell
                cell.ticket =  ticket
                cell.showsCheckbox = !self.editMode()
                cell.delegate = self
                
                cell.checked =  self.selectedIdentifiers.contains(ticket!.identifier!)
                
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    
    
    
    
    
}


extension BoardTableViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var newSection:String!
        
        if self.section == "Backlog" {
            newSection = ["Morning", "Afternoon","Evening"][indexPath.row]
        }
        else
        {
            newSection = ["Backlog", "Morning", "Afternoon","Evening"][indexPath.row]
        }
        
        for ticket in self.fetchedResultsController.fetchedObjects! as! [Ticket] {
            if self.selectedIdentifiers.contains(ticket.identifier!) {
                
                let maxRow = Ticket.spareRowForSection(self.section, moc: self.moc)
                
                if self.section == "Backlog" {
                    ticket.section = newSection
                    
                    ticket.row = Int32(maxRow)
                }
                else {
                    //copy
                    let newTicket = Ticket.createInMoc(self.moc)
                    newTicket.desc = ticket.desc
                    newTicket.name = ticket.name
                    newTicket.pomodoroEstimate = ticket.pomodoroEstimate
                    newTicket.section = newSection
                    newTicket.row = Int32(maxRow)
                    newTicket.colorIndex = ticket.colorIndex
                    newTicket.removed = ticket.removed
                }
            }
            
        }
        
        try! self.moc.save()
        
        MBProgressHUD.showAdded(to: self.tableView, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            MBProgressHUD.hide(for: self.tableView, animated: true)
            
        }
        
        
        
        self.selectedIdentifiers.removeAll()
        self.tableView.reloadData()
        self.collectionView.reloadData()
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
    }
}

extension BoardTableViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section != "Backlog" ? 4 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"moveCell", for: indexPath) as! SquareButtonCollectionViewCell
        
        if self.section != "Backlog" {
            
            cell.setupWith(title: ["Copy to Backlog","Copy to Morning", "Copy to Afternoon", "Copy to Evening"][indexPath.row])
        }
        else {
            cell.setupWith(title: ["Move to Morning", "Move to Afternoon", "Move to Evening"][indexPath.row])
        }
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 3
        cell.contentView.layer.borderColor = self.buttonsEnabled == true ? UIColor.red.cgColor : UIColor.darkGray.cgColor
        
        return cell
    }
    
}

extension BoardTableViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = UIScreen.main.bounds.width
        
        width = width - 50
        
        width = width / 4
        
        return CGSize(width:width,height:70)
    }
}


extension BoardTableViewController : TicketTableViewCellDelegate {
    func didSelectTicketWithIdentifier(identifier: String) {
        if self.selectedIdentifiers.contains(identifier) {
            self.selectedIdentifiers.remove(at: self.selectedIdentifiers.index(of: identifier)!)
        }
        else {
            self.selectedIdentifiers.append(identifier)
        }
        
    }
    
}

