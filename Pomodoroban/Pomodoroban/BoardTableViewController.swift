import UIKit
import CoreData
import Onboard
import Firebase
import FirebaseDatabase
import FirebaseAuth
import UserNotifications

class BoardTableViewController: UITableViewController {
    
    @IBAction func buyPressed(sender: AnyObject) {
        Products.instance().purchaseProduct("1")
    }
    
    @IBOutlet weak var layerButton: UIButton!
    
    var showAll = true
    
    var sectionHeaders = [UIView]()
    
    var isActuallyEditing = false
    
    let moc = CoreDataServices.sharedInstance.moc
    
    var childMoc:NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let tempFetchedResultsController = NSFetchedResultsController( fetchRequest: Ticket.fetchRequestAll(), managedObjectContext: self.moc, sectionNameKeyPath: "section", cacheName: nil)
        tempFetchedResultsController.delegate = self
        return tempFetchedResultsController
    }()
    
    @IBAction func addPressed(sender: AnyObject) {
        
        let section = self.showAll ? 0 : NSDate().getDayOfWeek()
        
        self.addInSection(section)
    }
    
    @IBAction func layerPressed(sender: AnyObject) {
        
        if  self.isActuallyEditing == false {
            
            
            self.isActuallyEditing = true
            self.setPlanMode()
        }
        else {
            self.isActuallyEditing = false
            self.setWorkMode()
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
        
        //       let bundle = NSBundle.mainBundle()
        //     let moviePath = bundle.pathForResource("IMG_6628", ofType: "MOV")
        //   let movieURL = NSURL(fileURLWithPath: moviePath!)
        
        let onboardingVC = OnboardingViewController(backgroundVideoURL: nil, contents: [firstPage, secondPage, thirdPage])
        
        
        
        self.presentViewController(onboardingVC, animated: true) {
            
        }
        
    }
    
    // lifetime
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        /*
         
         let tracker = GAI.sharedInstance().defaultTracker
         tracker.set(kGAIScreenName, value: "Main Screen")
         
         let builder = GAIDictionaryBuilder.createScreenView()
         tracker.send(builder.build() as [NSObject : AnyObject])
         */
        
        
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
        
        view.backgroundColor = UIColor(hexString: "e9ebd4")
        let label = UILabel(frame:CGRectMake(10,0,self.tableView.frame.size.width - 20,30))
        
        if (NSDate().getDayOfWeek() == section) {
            label.text = "TODAY"
            label.textColor = UIColor.darkGrayColor()
            
            label.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        }
        else {
            label.textColor = UIColor.darkGrayColor()
            
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
    
    
    func updateHeaderOnPurchaseStatus() {
        let products = Products.instance().productsArray
        
        if (products.firstObject?.purchased)! == true {
            self.tableView.tableHeaderView = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.currentNotificationCenter().requestAuthorizationWithOptions([.Alert,.Sound]) { (bool:Bool, error:NSError?) in
            
            self.updateHeaderOnPurchaseStatus()
        }
            NSNotificationCenter.defaultCenter().addObserverForName("productsRefreshed", object: nil, queue: nil) { (Notification) in
                
                self.updateHeaderOnPurchaseStatus()
                
            }
            
            BuddyBuildSDK.setup()
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if defaults.objectForKey("shownOnboarding") == nil {
                
                //    self.showOnboarding()
                
                defaults.setBool(true, forKey: "shownOnboarding")
                
                defaults.synchronize()
                
            }
            
            
            
            self.createSectionHeaders()
            
            try! self.fetchedResultsController.performFetch()
            
            self.tableView.allowsSelectionDuringEditing = true
            self.setWorkMode()
            
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
            
            self.title = "POMODOROBAN" // FIRAuth.auth()!.currentUser?.email
            SyncService.sharedInstance.setupSync()
     
    //    NSNotificationCenter.defaultCenter().addObserver(self, selector: "contextDidSaveContext:", name: NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
        
        func showLogin() {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            
            vc.delegate = self
            
            self.presentViewController(vc, animated: false, completion: {
                
            })
            
        }
        
        @IBAction func settingsPressed(sender: AnyObject) {
            
            let alert = UIAlertController(title: "Settings", message: nil, preferredStyle: .ActionSheet)
            
            
            
            if self.showAll == false {
                
                alert.addAction(UIAlertAction(title: "Show All Days", style: .Destructive, handler: { (action
                    ) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.showAll = true
                    self.tableView.reloadData()
                }))
            }
            else {
                
                alert.addAction(UIAlertAction(title: "Show Today and Backlog Only", style: .Destructive, handler: { (action
                    ) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.showAll = false
                    self.tableView.reloadData()
                }))
            }
            
            
            alert.addAction(UIAlertAction(title: "Sign Out", style: .Default, handler: { (action
                ) in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
                SyncService.sharedInstance.removeAllForSignOut()
                try! FIRAuth.auth()!.signOut()
                self.showLogin()
                
                
            }))
            
            
            alert.addAction(UIAlertAction(title: "Restore Purchase", style: .Default, handler: { (action
                ) in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
                Products.instance().restoreAllProducts()
                
            }))
            
            
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action
                ) in
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
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
    
        func setWorkMode() {
            self.tableView.setEditing(false, animated: true)
            
            self.layerButton.setImage(UIImage(named:"layers"), forState: .Normal)
            
            UIView.animateWithDuration(0.3, animations: {
                self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
            })
        }
        
        func setPlanMode() {
            self.tableView.setEditing(true, animated: true)
            self.layerButton.setImage(UIImage(named:"layersOn"), forState: .Normal)
            
            
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
                return currentSection.numberOfObjects == 0 ? 0 : currentSection.numberOfObjects - 1
            }
            return 0
        }
        
        override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
            let ticket = fetchedResultsController.objectAtIndexPath(sourceIndexPath) as? Ticket
            Ticket.insertTicket(ticket!, toIndexPath: destinationIndexPath, moc:self.moc)
        }
        
        override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            return true
        }
        
        func hiddenSections() -> [Int] {
            var array = [0,1,2,3,4,5,6,7]
            array.removeAtIndex(NSDate().getDayOfWeek())
            return array
        }
        
        override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            
            if self.showAll == false {
                if self.hiddenSections().contains(indexPath.section) == true {
                    return 0
                }
            }
            return 66
        }
        
        override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
            return .Delete
        }
        
        override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == .Delete {
                if let ticket = fetchedResultsController.objectAtIndexPath(indexPath) as? Ticket {
                    
                    ticket.removed = true
                    
                    try! self.moc.save()
                }
            }
            else if editingStyle == .Insert {
                self.addInSection(indexPath.section)
            }
        }
        
    
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let ticket = fetchedResultsController.objectAtIndexPath(indexPath) as? Ticket
            let cell = tableView.dequeueReusableCellWithIdentifier("TicketTableViewCell") as! TicketTableViewCell
            cell.ticket =  ticket
            return cell
        }
    
        override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if self.showAll == false {
                if self.hiddenSections().contains(section) == true {
                    return 0
                }
            }
            return 30
        }
        
        override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
            let view = self.sectionHeaders[section]
            print(view)
            
            return view
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
            
                let nc = self.storyboard?.instantiateViewControllerWithIdentifier("TicketNavigationViewController") as! UINavigationController
                let vc = nc.viewControllers[0] as! TicketViewController
                
                
                self.childMoc = CoreDataServices.sharedInstance.childMoc()
                vc.ticket = Ticket.ticketForTicket(self.fetchedResultsController.objectAtIndexPath(indexPath) as! Ticket, moc:self.childMoc)
                
                vc.delegate = self
                
                self.presentViewController(nc, animated: true) {}
        }
    }
    
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
    }
    
    extension BoardTableViewController : NSFetchedResultsControllerDelegate {
        
        func controllerWillChangeContent(controller: NSFetchedResultsController) {
     
            
            if self.isActuallyEditing {
                self.tableView.reloadData()
                return
            }
            
            self.tableView.beginUpdates()
            
        }
        
        func controller(
            controller: NSFetchedResultsController,
            didChangeObject anObject: AnyObject,
                            atIndexPath indexPath: NSIndexPath?,
                                        forChangeType type: NSFetchedResultsChangeType,
                                                      newIndexPath: NSIndexPath?) {
            
            if self.isActuallyEditing {
                return
            }
    
            
            switch type {
            case NSFetchedResultsChangeType.Insert:
                if let insertIndexPath = newIndexPath {
                    self.tableView.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: UITableViewRowAnimation.Right)
                }
            case NSFetchedResultsChangeType.Delete:
                if let deleteIndexPath = indexPath {
                    self.tableView.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
            case NSFetchedResultsChangeType.Update:
          
                
                if let indexPath = indexPath , newIndexPath = newIndexPath {
                    
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
                    
                        self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Right)
                    
                    
                }
                
                else {
                    self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                    
                }
                
            case NSFetchedResultsChangeType.Move:
            
                
                
                if let deleteIndexPath = indexPath {
                    self.tableView.deleteRowsAtIndexPaths([deleteIndexPath], withRowAnimation: UITableViewRowAnimation.Left)
                }
                
                if let insertIndexPath = newIndexPath {
                    self.tableView.insertRowsAtIndexPaths([insertIndexPath], withRowAnimation: UITableViewRowAnimation.Right)
                }
                
                
                
            }
        }
        
        
        func controllerDidChangeContent(controller: NSFetchedResultsController) {
         
          //  self.reloadSectionHeaders()
            
            
            if self.isActuallyEditing {
                return
            }
            tableView.endUpdates()
        }
        
    }
    
    
    extension BoardTableViewController : LoginViewControllerDelegate {
        func loginViewControllerDidSignIn(loginViewController: LoginViewController) {
        }
}
