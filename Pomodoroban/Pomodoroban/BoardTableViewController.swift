import UIKit
import CoreData
import Onboard
import Firebase
import FirebaseDatabase
import FirebaseAuth
import UserNotifications
//import EasyTipView

class BoardTableViewController: UITableViewController {
    
    @IBOutlet weak var settingsButton: UIButton!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.setEditing(true, animated: true)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "productsRefreshed"), object: nil, queue: nil) { (Notification) in
            
            
        }
        try! self.fetchedResultsController.performFetch()
        self.tableView.allowsSelectionDuringEditing = true
        self.tableView.tableFooterView = UIView()
        self.navigationController!.redWithLogo()
        self.tableView.tableHeaderView = nil
        self.title = section
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func showLogin(_ register:Bool) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        vc.delegate = self
        if register == true {
            
            vc.mode = .signupOnly
        }
        else {
            vc.mode = .login
        }
        
        self.present(vc, animated: false, completion: {
        })
        
    }
    /*
     @IBAction func settingsPressed(_ sender: AnyObject) {
     
     let alert = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
     
     alert.addAction(UIAlertAction(title: "Select Sections", style: .destructive, handler: { (action
     ) in
     self.dismiss(animated: true, completion: nil)
     let nc = UIStoryboard(name:"SectionSelect", bundle:nil).instantiateInitialViewController() as! UINavigationController
     
     let vc = nc.viewControllers.first! as! SectionSelectTableViewController
     
     vc.sectionTitles = self.sectionTitles()
     vc.selectedSectionTitles = self.selectedSectionTitles()
     vc.delegate = self
     
     self.present(nc, animated: true, completion: {})
     }))
     
     if  Auth.auth().currentUser?.uid == nil {
     alert.addAction(UIAlertAction(title: "Register for sync", style: .destructive, handler: { (action
     ) in
     self.showLogin(true)
     }))
     }
     else {
     
     alert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (action
     ) in
     
     self.dismiss(animated: true, completion: nil)
     
     
     let defaults = UserDefaults.standard
     
     defaults.removeObject(forKey: "loggedInWithoutAuth")
     
     defaults.synchronize()
     
     
     
     
     SyncService.sharedInstance.removeAllForSignOut()
     try! Auth.auth().signOut()
     self.showLogin(false)
     
     
     }))
     }
     
     alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action
     ) in
     }))
     
     alert.popoverPresentationController?.sourceView = self.settingsButton
     
     self.present(alert, animated: true, completion: nil)
     
     
     }
     */
    // general
    

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
            if Ticket.allForToday(self.moc).count < 1 {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                
                let day = dateFormatter.string(from: Date())
                
                let alert = UIAlertController(title: "Oops", message: "There need to be some Stories in \(day) for this to work!", preferredStyle: .alert)
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if let sections = self.fetchedResultsController.sections {
            if sections.count == 0 {
                return 0
            }
            
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let ticket = fetchedResultsController.object(at: sourceIndexPath) as? Ticket
        Ticket.insertTicket(ticket!, row: destinationIndexPath.row,section:self.section, moc:self.moc)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let ticket = fetchedResultsController.object(at: indexPath) as? Ticket {
                
                ticket.removed = true
                
                try! self.moc.save()
            }
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let sections = self.fetchedResultsController.sections {
            let currentSection = sections[indexPath.section]
            if indexPath.row < currentSection.numberOfObjects {
                
                
                let ticket = fetchedResultsController.object(at: indexPath) as? Ticket
                let cell = tableView.dequeueReusableCell(withIdentifier: "TicketTableViewCell") as! TicketTableViewCell
                cell.ticket =  ticket
                
                //         cell.dlabel.text = "s:\(cell.ticket!.section) - r:\(cell.ticket!.row)"
                return cell
            }
        }
        
        return UITableViewCell()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let nc = self.storyboard?.instantiateViewController(withIdentifier: "TicketNavigationViewController") as! UINavigationController
        let vc = nc.viewControllers[0] as! TicketViewController
        
        self.childMoc = CoreDataServices.sharedInstance.childMoc()
        vc.ticket = Ticket.ticketForTicket(self.fetchedResultsController.object(at: indexPath) as! Ticket, moc:self.childMoc)
        
        vc.delegate = self
        
        self.present(nc, animated: true) {}
    }
    
    
}

extension BoardTableViewController : TicketViewControllerDelegate {
    func ticketViewControllerSave(_ ticketViewController: TicketViewController) {
        
        self.dismiss(animated: true) {
            self.saveChildMoc()
        }
    }
    
    func ticketViewControllerCancel(_ ticketViewController: TicketViewController) {
        
        self.dismiss(animated: true) {
        }
    }
}

extension BoardTableViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        
        
        self.tableView.beginUpdates()
        
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        
        
        
        
        switch type {
        case NSFetchedResultsChangeType.insert:
            if let insertIndexPath = newIndexPath {
                self.tableView.insertRows(at: [insertIndexPath], with: UITableViewRowAnimation.right)
            }
        case NSFetchedResultsChangeType.delete:
            if let deleteIndexPath = indexPath {
                self.tableView.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.fade)
            }
        case NSFetchedResultsChangeType.update:
            
            
            if let indexPath = indexPath , let newIndexPath = newIndexPath {
                
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
                
                self.tableView.insertRows(at: [newIndexPath], with: UITableViewRowAnimation.right)
                
                
            }
                
            else {
                self.tableView.reloadRows(at: [indexPath!], with: .fade)
                
            }
            
        case NSFetchedResultsChangeType.move:
            
            
            
            if let deleteIndexPath = indexPath {
                self.tableView.deleteRows(at: [deleteIndexPath], with: UITableViewRowAnimation.left)
            }
            
            if let insertIndexPath = newIndexPath {
                self.tableView.insertRows(at: [insertIndexPath], with: UITableViewRowAnimation.right)
            }
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        
        tableView.endUpdates()
    }
    
}

extension BoardTableViewController : LoginViewControllerDelegate {
    func loginViewControllerDidSignIn(_ loginViewController: LoginViewController) {
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
