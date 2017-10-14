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
    
    @IBAction func buyPressed(_ sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BuyViewController") as! BuyViewController
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
   @IBOutlet weak var layerButton: UIButton!
    
    var showAll = true
    
    var sectionHeaders = [UIView]()
    
    var isActuallyEditing = false
    
    let moc = CoreDataServices.sharedInstance.moc
    
    var childMoc:NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let tempFetchedResultsController = NSFetchedResultsController( fetchRequest: Ticket.fetchRequestAll(), managedObjectContext: self.moc, sectionNameKeyPath: "section", cacheName: nil)
        tempFetchedResultsController.delegate = self
        return tempFetchedResultsController
    }()
    
    @IBAction func addPressed(_ sender: AnyObject) {
        
        let section = self.showAll ? 0 : Date().getDayOfWeek()
        
        self.addInSection(section)
    }
    
    @IBAction func layerPressed(_ sender: AnyObject) {
        
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
            
            self.dismiss(animated: true, completion: {
                
            })
        }
        
        //       let bundle = NSBundle.mainBundle()
        //     let moviePath = bundle.pathForResource("IMG_6628", ofType: "MOV")
        //   let movieURL = NSURL(fileURLWithPath: moviePath!)
        
        let onboardingVC = OnboardingViewController(backgroundVideoURL: nil, contents: [firstPage, secondPage, thirdPage])
        
        
        
        self.present(onboardingVC!, animated: true) {
            
        }
        
    }
    
    // lifetime
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
         
         FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
         kFIRParameterContentType: "Main Screen" as NSObject
         ])
         */
    }
    func selectedSectionTitles() -> [String] {
        
        let defaults = UserDefaults.standard
        
        let key = defaults.value(forKey: "selectedSectionTitles")
        
        if key == nil {
            defaults.setValue(["INBOX", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY", "DONE"], forKey: "selectedSectionTitles")
            defaults.synchronize()
        }
        
        return defaults.value(forKey:"selectedSectionTitles") as! [String]
    }
    
    func sectionTitles() -> [String] {
        return ["INBOX", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY", "DONE"]
    }
    
    func updateViewForSection(_ view:UIView, section: Int)  {
        
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        view.frame = CGRect(x: 0,y: 0,width: self.tableView.frame.size.width,height: 30)
        
        let countLabel = UILabel(frame:CGRect(x: self.tableView.frame.size.width-50,y: 0,width: 40,height: 30))
        countLabel.textColor = UIColor.black
        countLabel.textAlignment = .right
        
        
        let count = Ticket.countForSection(moc, section:section)
        
        
        if count > 0 {
            countLabel.text = "\(count)"
        }
        
        view.backgroundColor = UIColor(hexString: "e9ebd4")
        let label = UILabel(frame:CGRect(x: 10,y: 0,width: self.tableView.frame.size.width - 20,height: 30))
        
        if (Date().getDayOfWeek() == section) {
            label.text = "TODAY"
            label.textColor = UIColor.darkGray
            
            label.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        }
        else {
            label.textColor = UIColor.darkGray
            
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
    
    /*
    func updateHeaderOnPurchaseStatus() {
        let products = Products.instance().productsArray
        
        if ((products?.firstObject as AnyObject).purchased)! == true {
            self.tableView.tableHeaderView = nil
            
            UserDefaults.standard.set(true, forKey: "purchased")
            UserDefaults.standard.synchronize()
            
        }
    }
    */
    
    @objc func dayChanged(_ notification: Notification){
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        NotificationCenter.default.addObserver(self, selector: #selector(BoardTableViewController.dayChanged(_:)), name: NSNotification.Name.UIApplicationSignificantTimeChange, object: nil)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { (granted:Bool, error:Error?) in
            
        }
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "productsRefreshed"), object: nil, queue: nil) { (Notification) in
            
           // self.updateHeaderOnPurchaseStatus()
            
        }
        
        BuddyBuildSDK.setup()
        
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "shownOnboarding") == nil {
            
            //    self.showOnboarding()
            
            defaults.set(true, forKey: "shownOnboarding")
            
            defaults.synchronize()
            
        }
        
        self.createSectionHeaders()
        
        try! self.fetchedResultsController.performFetch()
        
        self.tableView.allowsSelectionDuringEditing = true
        self.setWorkMode()
        
        self.tableView.tableFooterView = UIView()
        
        
        self.navigationController!.redWithLogo()
        
        if Runtime.all(self.moc).count > 0 {
            
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "TimerViewController")
            
            self.present(vc, animated: false, completion: {
                
            })
        }
        
        self.title = "Life Tracker"
        
        let purchased = UserDefaults.standard.bool(forKey: "purchased")
        
        if purchased == true {
            self.tableView.tableHeaderView = nil
        }
        
        self.tableView.tableHeaderView = nil
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func showLogin(_ register:Bool) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
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
    // general
    
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
    
    func setWorkMode() {
        self.tableView.setEditing(false, animated: true)
        
        self.layerButton.setImage(UIImage(named:"layers"), for: UIControlState())
        
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.navigationBar.barTintColor = UIColor.red
        })
    }
    
    func setPlanMode() {
        self.tableView.setEditing(true, animated: true)
        self.layerButton.setImage(UIImage(named:"layersOn"), for: UIControlState())
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.navigationBar.barTintColor = UIColor.black
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.sectionTitles().count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects == 1 ? 0 : currentSection.numberOfObjects - 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let ticket = fetchedResultsController.object(at: sourceIndexPath) as? Ticket
        Ticket.insertTicket(ticket!, toIndexPath: destinationIndexPath, moc:self.moc)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return SyncService.sharedInstance.connected
    }
    
    func hiddenSections() -> [Int] {
        
        var array = [Int]()
        
        var index = 0
        
        for item in self.sectionTitles() {
            if !self.selectedSectionTitles().contains(item){
                array.append(index)
            }
            
            index = index + 1
        }
        
        return array
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.hiddenSections().contains(indexPath.section) == true {
            return 0
        }
        
        return 66
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
        else if editingStyle == .insert {
            self.addInSection(indexPath.section)
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.hiddenSections().contains(section) == true {
            return 0
        }
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = self.sectionHeaders[section]
        
        return view
    }
    
    
    func spareRowForSection(_ section: Int) -> Int{
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
    
    func addInSection(_ section:Int) {
        let nc = self.storyboard?.instantiateViewController(withIdentifier: "TicketNavigationViewController") as! UINavigationController
        let vc = nc.viewControllers[0] as! TicketViewController
        
        vc.setFocusToName = true
        
        let row = Ticket.spareRowForSection(section, moc:self.moc)
        
        self.childMoc = CoreDataServices.sharedInstance.childMoc()
        vc.ticket = Ticket.createInMoc(self.childMoc)
        vc.ticket.name = ""
        vc.ticket.row = Int32(row)
        vc.ticket.section = Int32(section)
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
        
        
        if self.isActuallyEditing {
            return
        }
        
        
        self.tableView.beginUpdates()
        
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        
        if self.isActuallyEditing {
            return
        }
        
        
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
        
        if self.isActuallyEditing {
            self.tableView.reloadData()
            self.reloadSectionHeaders()
            return
        }
        
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
