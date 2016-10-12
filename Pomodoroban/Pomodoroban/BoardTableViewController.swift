import UIKit
import CoreData
import Onboard

class BoardTableViewController: UITableViewController {
    
    // vars
    
    var sectionHeaders = [UIView]()
    
    var isActuallyEditing = false
    
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
        
        if  self.isActuallyEditing == false {
            
            
            self.isActuallyEditing = true
            self.setPlanMode()
            self.reloadAddCells()
        }
        else {
            self.isActuallyEditing = false
            self.setWorkMode()
            self.reloadAddCells()
        }
    }
    
    
    func showOnboarding() {
        
        
        
        let firstPage = OnboardingContentViewController(title: "Page Title", body: "Page body goes here.", image: UIImage(named: "icon"), buttonText: "Text For Button") { () -> Void in
        }
        
        let secondPage = OnboardingContentViewController(title: "Page Title", body: "Page body goes here.", image: UIImage(named: "icon"), buttonText: "Text For Button") { () -> Void in
        }
 
        let thirdPage = OnboardingContentViewController(title: "Page Title", body: "Page body goes here.", image: UIImage(named: "icon"), buttonText: "Done") { () -> Void in
        
        self.dismissViewControllerAnimated(true, completion: { 
            
        })
        }
        
        let bundle = NSBundle.mainBundle()
        let moviePath = bundle.pathForResource("IMG_6628", ofType: "MOV")
        let movieURL = NSURL(fileURLWithPath: moviePath!)
        
        let onboardingVC = OnboardingViewController(backgroundVideoURL: movieURL, contents: [firstPage, secondPage, thirdPage])
        
        
        
        self.presentViewController(onboardingVC, animated: true) { 
            
        }
        
    }
    
    // lifetime
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Main Screen")
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func sectionTitles() -> [String] {
        return ["BACKLOG", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY", "DONE"]
    }
    
    func updateViewForSection(view:UIView, section: Int)  {
     
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        view.frame = CGRectMake(0,0,self.tableView.frame.size.width,30)
        
        let countLabel = UILabel(frame:CGRectMake(self.tableView.frame.size.width-50,0,40,30))
        countLabel.textColor = UIColor.whiteColor()
        countLabel.textAlignment = .Right
        
        
        let count = Ticket.countForSection(moc, section:section)
        
        
        if count > 0 {
        countLabel.text = "\(count)"
        }
        
        view.backgroundColor = UIColor.darkGrayColor()// UIColor(hexString: "1fa511")
        let label = UILabel(frame:CGRectMake(10,0,self.tableView.frame.size.width - 20,30))
        
        if (NSDate().getDayOfWeek() == section) {
            label.text = "TODAY"
            label.textColor = UIColor.whiteColor()
            
            label.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        }
        else {
            label.textColor = UIColor.whiteColor()
            
            label.text = self.sectionTitles()[section]
            
            label.font = UIFont(name:"HelveticaNeue", size: 18.0)
        }
  
        view.addSubview(label)
        
        view.addSubview(countLabel)
        
    }
    
    
    func reloadSectionHeaders() {
        
        var index = 0
        
        for view in self.sectionHeaders {
            
            self.updateViewForSection(view, section: index)
            
            index = index + 1
            
            
        }
    }
    
    
    
    func createSectionHeaders() {
        
        var index = 0
        
        for _ in self.sectionTitles() {
        
            let view = UIView()
            
            self.updateViewForSection(view, section:index)
            
            index = index + 1
            
            self.sectionHeaders.append(view)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.objectForKey("shownOnboarding") == nil {
        
            self.showOnboarding()
            
            defaults.setBool(true, forKey: "shownOnboarding")
            
            defaults.synchronize()
            
        }
        
        
        
        self.createSectionHeaders()
        
        try! self.fetchedResultsController.performFetch()
        
        self.tableView.allowsSelectionDuringEditing = true
        self.setWorkMode()
        
        self.navigationController?.toolbarHidden = false
        
        //    self.toolbarItems = "hello"
        
        
        self.tableView.tableFooterView = UIView()
        
        
        self.navigationController?.navigationBar.translucent = false
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        
        if Runtime.all(self.moc).count > 0 {
            
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("TimerViewController")
            
            self.presentViewController(vc, animated: false, completion: { 
                
            })
        }
    }
    
    // general
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if Ticket.allForToday(self.moc).count < 1 {
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE"
            
            let day = dateFormatter.stringFromDate(NSDate())
            
            let alert = UIAlertController(title: "Oops", message: "There need to be some pomodoro in \(day) for this to work!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
            
        else {
            return true
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
        
        UIView.animateWithDuration(0.3, animations: {
            self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        })
    }
    
    func setPlanMode() {
        self.tableView.setEditing(true, animated: true)
        self.title = "PLANNING"
        self.planWorkButton.title = "Work"
        
        
        UIView.animateWithDuration(0.3, animations: {
            self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.sectionTitles().count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            let currentSection = sections[section]
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
        return self.isAddAtIndexPath(indexPath) ? ( self.isActuallyEditing ? 66 : 0 ) :  66
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return self.isAddAtIndexPath(indexPath) == true ?  .Insert :  .Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let ticket = fetchedResultsController.objectAtIndexPath(indexPath) as? Ticket {
                
                self.moc.deleteObject(ticket)
                
                try! self.moc.save()
            }
        }
        else if editingStyle == .Insert {
            self.addInSection(indexPath.section)
        }
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
        
        //    cell.dlabel.text = "s:\(cell.ticket!.section) - r:\(cell.ticket!.row)"
        
        return cell
    }
    
    
    func isAddAtIndexPath(indexPath:NSIndexPath) -> Bool {
        
        if let sections = self.fetchedResultsController.sections {
            let currentSection = sections[indexPath.section]
            return currentSection.numberOfObjects-1 == indexPath.row
        }
        return false
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeaders[section]
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
        let nc = self.storyboard?.instantiateViewControllerWithIdentifier("TicketNavigationViewController") as! UINavigationController
        let vc = nc.viewControllers[0] as! TicketViewController
        
        let row = Ticket.spareRowForSection(section, moc:self.moc)
        
        self.childMoc = CoreDataServices.sharedInstance.childMoc()
        vc.ticket = Ticket.createInMoc(self.childMoc)
        vc.ticket.name = ""
        vc.ticket.row = Int32(row)
        vc.ticket.section = Int32(section)
        vc.ticket.pomodoroEstimate = 1
        vc.ticket.colorIndex = 2
        
        vc.delegate = self
        
        self.presentViewController(nc, animated: true) {}
        
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
            
            let nc = self.storyboard?.instantiateViewControllerWithIdentifier("TicketNavigationViewController") as! UINavigationController
            let vc = nc.viewControllers[0] as! TicketViewController
            
            
            self.childMoc = CoreDataServices.sharedInstance.childMoc()
            vc.ticket = Ticket.ticketForTicket(self.fetchedResultsController.objectAtIndexPath(indexPath) as! Ticket, moc:self.childMoc)
            
            vc.delegate = self
            
            self.presentViewController(nc, animated: true) {}
        }
        else {
            self.addInSection(indexPath.section)
        }
    }
    
    
    
}

// extensions

extension BoardTableViewController : TicketViewControllerDelegate {
    func ticketViewControllerSave(ticketViewController: TicketViewController) {
        
        self.dismissViewControllerAnimated(true) {
            self.saveChildMoc()
        }
        
    }
    
    func ticketViewControllerCancel(ticketViewController: TicketViewController) {
        
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    
    /*
     func pomodoroViewControllerDelegateDone(pomodoroViewController: PomodoroViewController, ticket:Ticket) {
     self.dismissViewControllerAnimated(true) {
     ticket.row = Int32( self.spareRowForSection(Int( ticket.section)))
     ticket.section = 8
     self.saveChildMoc()
     }
     }
     */
    
}

extension BoardTableViewController : NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        self.reloadSectionHeaders()
        
        tableView.reloadData()
    }
    
}

