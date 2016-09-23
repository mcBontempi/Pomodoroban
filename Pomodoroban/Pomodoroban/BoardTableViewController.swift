import UIKit
import CoreData

class BoardTableViewController: UITableViewController {
    
    let moc = AppDelegate.getMe().moc
    
    var childMoc:NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let tempFetchedResultsController = NSFetchedResultsController( fetchRequest: Ticket.fetchRequestAll(), managedObjectContext: self.moc, sectionNameKeyPath: "section", cacheName: nil)
        tempFetchedResultsController.delegate = self
        return tempFetchedResultsController
    }()
    
    @IBOutlet weak var planWorkButton: UIBarButtonItem!
    @IBAction func PlanWordPressed(sender: AnyObject) {
        
        if  self.tableView.editing == false {
            self.setPlanMode()
            self.reloadAddCells()
        }
        else {
            self.setWorkMode()
            self.reloadAddCells()
        }
    }
    
    
    func reloadAddCells() {
        self.tableView.beginUpdates()
        
        var indexPaths = [NSIndexPath]()
        
        for sectionIndex in 0 ... 8 {
            
            indexPaths.append(  NSIndexPath(forRow:self.tableView.numberOfRowsInSection(sectionIndex)-1, inSection:  sectionIndex))
            
        }
        
        self.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        
        self.tableView.endUpdates()
    }
    
    
    func setWorkMode() {
        self.tableView.setEditing(false, animated: true)
        self.title = "POMODOROBAN"
        
        self.planWorkButton.title = "Plan"
        
        UIView.animateWithDuration(1.0, animations: {
            self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        })
    }
    
    func setPlanMode() {
        self.tableView.setEditing(true, animated: true)
        self.title = "Editing Mode"
        self.planWorkButton.title = "Work"
        
        
        UIView.animateWithDuration(1.0, animations: {
            self.navigationController?.navigationBar.backgroundColor = UIColor.redColor()
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! self.fetchedResultsController.performFetch()
        
        self.tableView.allowsSelectionDuringEditing = true
        self.setWorkMode()
        
       
    }
    @IBAction func addPressed(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PomodoroViewController") as! PomodoroViewController
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.sectionTitles().count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            let currentSection = sections[section]
            print(currentSection.numberOfObjects)
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let ticket = fetchedResultsController.objectAtIndexPath(sourceIndexPath) as? Ticket
        
        Ticket.insertTicket(ticket!, toIndexPath: destinationIndexPath, moc:self.moc)
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.isAddAtIndexPath(indexPath)
    }
    
    
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.isAddAtIndexPath(indexPath) ? ( self.tableView.editing ? 60 : 0 ) :  40
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        return self.isAddAtIndexPath(indexPath) == true ?  .Insert :  .Delete
        
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        
        var realProposed = proposedDestinationIndexPath
        
        if proposedDestinationIndexPath.section == sourceIndexPath.section {
            realProposed = NSIndexPath(forRow: proposedDestinationIndexPath.row-1, inSection: proposedDestinationIndexPath.section)
        }
        
        
        return self.isAddAtIndexPath(proposedDestinationIndexPath) ? realProposed : sourceIndexPath
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let ticket = fetchedResultsController.objectAtIndexPath(indexPath) as? Ticket
        let cell = tableView.dequeueReusableCellWithIdentifier("TicketTableViewCell") as! TicketTableViewCell
        cell.isAddCell = self.isAddAtIndexPath(indexPath)
        cell.ticket =  ticket
        return cell
    }
    
    
    func isAddAtIndexPath(indexPath:NSIndexPath) -> Bool {
        
        if let sections = self.fetchedResultsController.sections {
            let currentSection = sections[indexPath.section]
            return currentSection.numberOfObjects-1 == indexPath.row
        }
        return false
        
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles()[section]
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Insert {
            
            
            
            let nc = self.storyboard?.instantiateViewControllerWithIdentifier("PomodoroNavigationViewController") as! UINavigationController
            let vc = nc.viewControllers[0] as! PomodoroViewController
            
            self.childMoc = AppDelegate.getMe().childMoc()
            vc.ticket = Ticket.createInMoc(self.childMoc)
            vc.ticket.name = "DDT"
            vc.ticket.row = Int32(indexPath.row+1)
            vc.ticket.section = Int32(indexPath.section)
            
            vc.delegate = self
            
            self.saveChildMoc()
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            
            
        //    self.presentViewController(nc, animated: true) {}
            
        }
    }
    
    func saveChildMoc() {
        if self.childMoc != nil {
            self.moc.performBlock({
                try! self.childMoc.save()
                self.childMoc = nil
            
                self.moc.performBlock({
                    try! self.moc.save()
            //try! self.moc.save()
                })
            })
        }
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    
    func sectionTitles() -> [String] {
        return ["BACKLOG", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY", "DONE"]
    }
    
}

// extensions

extension BoardTableViewController : PomodoroViewControllerDelegate {
    func pomodoroViewControllerDelegateSave(pomodoroViewController: PomodoroViewController) {
        self.dismissViewControllerAnimated(true) {
        //           self.tableView.beginUpdates()
     //       Ticket.removeAllAddTickets(self.moc)
            
            
       //     Ticket.createAllAddTickets(self.moc)
        self.saveChildMoc()
        //         self.tableView.endUpdates()
            
        }
        
    }
    
    func pomodoroViewControllerDelegateCancal(pomodoroViewController: PomodoroViewController) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
}

extension BoardTableViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView?.reloadData()
    }
}
