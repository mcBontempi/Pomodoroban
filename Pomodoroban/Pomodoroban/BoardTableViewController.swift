import UIKit
import CoreData

class BoardTableViewController: UITableViewController {
    
    // vars
    
    let moc = CoreDataServices.sharedInstance.moc
    var childMoc:NSManagedObjectContext!
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let tempFetchedResultsController = NSFetchedResultsController( fetchRequest: Ticket.fetchRequestAll(), managedObjectContext: self.moc, sectionNameKeyPath: "section", cacheName: nil)
        tempFetchedResultsController.delegate = self
        return tempFetchedResultsController
    }()
    
    // outlets
    
    @IBOutlet weak var planWorkButton: UIBarButtonItem!
    
    // actions
    
    @IBAction func addPressed(sender: AnyObject) {
        self.addInSection(0)
    }
    
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
    
    // lifetime
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! self.fetchedResultsController.performFetch()
        
        self.tableView.allowsSelectionDuringEditing = true
        self.setWorkMode()
        
        self.navigationController?.toolbarHidden = false
        
    //    self.toolbarItems = "hello"
        
        
        self.tableView.tableFooterView = UIView()
    }
    
    // general
    
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
        
        UIView.animateWithDuration(0.3, animations: {
            self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        })
    }
    
    func setPlanMode() {
        self.tableView.setEditing(true, animated: true)
        self.title = "Editing Mode"
        self.planWorkButton.title = "Work"
        
        
        UIView.animateWithDuration(0.3, animations: {
            self.navigationController?.navigationBar.backgroundColor = UIColor.redColor()
        })
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
        return !self.isAddAtIndexPath(indexPath)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.isAddAtIndexPath(indexPath) ? ( self.tableView.editing ? 50 : 0 ) :  50
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return self.isAddAtIndexPath(indexPath) == true ?  .Insert :  .Delete
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        
        var realProposed = proposedDestinationIndexPath
        
        if proposedDestinationIndexPath.section == sourceIndexPath.section {
            realProposed = NSIndexPath(forRow: proposedDestinationIndexPath.row, inSection: proposedDestinationIndexPath.section)
        }
        else {
            realProposed = NSIndexPath(forRow: proposedDestinationIndexPath.row-1, inSection: proposedDestinationIndexPath.section)
            
        }
        return !self.isAddAtIndexPath(realProposed) ? proposedDestinationIndexPath : sourceIndexPath
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
    
    func spareRowForSection(section: Int) -> Int{
        var row:Int = 0
        if let sections = self.fetchedResultsController.sections {
            let currentSection = sections[section]
            
            let rowCountForSection = currentSection.objects!.count
            
            if rowCountForSection == 1 {
                row = 0
            }
            else {
                
                if let objects = currentSection.objects as? [Ticket]{
                    
                    let ticket = objects[rowCountForSection - 2]
                    row = Int(ticket.row) + 1
                }
            }
        }
        
        return Int(row)
        
    }
    
    func addInSection(section:Int) {
        let nc = self.storyboard?.instantiateViewControllerWithIdentifier("PomodoroNavigationViewController") as! UINavigationController
        let vc = nc.viewControllers[0] as! PomodoroViewController
        
        let row = self.spareRowForSection(section)
        
        self.childMoc = CoreDataServices.sharedInstance.childMoc()
        vc.ticket = Ticket.createInMoc(self.childMoc)
        vc.ticket.name = ""
        vc.ticket.row = Int32(row)
        vc.ticket.section = Int32(section)
        
        vc.delegate = self
        
        self.presentViewController(nc, animated: true) {}
        
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Insert {
            self.addInSection(indexPath.section)
        }
    }
    
    func saveChildMoc() {
        
        if self.childMoc != nil {
            self.moc.performBlockAndWait({
                try! self.childMoc.save()
                self.childMoc = nil
                
                self.moc.performBlockAndWait({
                    try! self.moc.save()
                })
            })
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row < self.tableView.numberOfRowsInSection(indexPath.section)-1 {
            
            let nc = self.storyboard?.instantiateViewControllerWithIdentifier("PomodoroNavigationViewController") as! UINavigationController
            let vc = nc.viewControllers[0] as! PomodoroViewController
            
            
            self.childMoc = CoreDataServices.sharedInstance.childMoc()
            vc.ticket = Ticket.ticketForTicket(self.fetchedResultsController.objectAtIndexPath(indexPath) as! Ticket, moc:self.childMoc)
            
            vc.delegate = self
            
            self.presentViewController(nc, animated: true) {}
        }
        else {
            self.addInSection(indexPath.section)
        }
    }
    
    
    func sectionTitles() -> [String] {
        return ["BACKLOG", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY", "DONE"]
    }
    
}

// extensions

extension BoardTableViewController : PomodoroViewControllerDelegate {
    func pomodoroViewControllerDelegateSave(pomodoroViewController: PomodoroViewController) {
        self.dismissViewControllerAnimated(true) {
            self.saveChildMoc()
        }
        
    }
    
    func pomodoroViewControllerDelegateCancal(pomodoroViewController: PomodoroViewController) {
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    func pomodoroViewControllerDelegateDone(pomodoroViewController: PomodoroViewController, ticket:Ticket) {
        self.dismissViewControllerAnimated(true) {
            ticket.row = Int32( self.spareRowForSection(Int( ticket.section)))
            ticket.section = 8
            self.saveChildMoc()
        }
    }
    
}

extension BoardTableViewController : NSFetchedResultsControllerDelegate {
    
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
}

