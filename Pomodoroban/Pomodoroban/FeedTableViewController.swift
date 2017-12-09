import UIKit
import CoreData
import FirebaseAuth

class FeedTableViewController: UITableViewController {
    
    let moc = CoreDataServices.sharedInstance.moc
    var childMoc:NSManagedObjectContext!
    var lasty = CGFloat(0.0)
    
    func reloadTable() {
        self.tableView.reloadData()
    }
    
    func dayChanged(notification: Notification) {
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        NotificationCenter.default.addObserver(self, selector: Selector("dayChanged:"), name: NSNotification.Name.UIApplicationSignificantTimeChange, object: nil)
        
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        
        
        var frame = self.tableView.bounds
        frame.origin.y = -frame.size.height
        let view = UIView(frame: frame)
        view.backgroundColor = .red
        self.tableView.addSubview(view)
        
        
        self.tableView.backgroundColor = UIColor.white
        

        
        // self.navigationController!.redWithLogo()
        let imageView = UIImageView(image:UIImage(named:"Calchua"))
        
        imageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = imageView
        
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    class func sections() -> [String] {
        return ["Backlog","Morning","Afternoon","Evening"]
    }
    
    func data() -> [(String,String)]
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        
        let dateString = formatter.string(from: Date())
        
        
        var rows =  [("userHeader",dateString)]
        
        
        rows.append(("userSwipe",""))
        
        let alerts = Alert.all(self.moc)
        
        if alerts.count > 0 {
            rows.append(contentsOf:[("alertHeader","")])
            
            for alert in alerts {
                rows.append(contentsOf:[("alert",alert.message)])
            }
            
        }
        
        rows.append(contentsOf:[("createHeader",""),("createSwipe",""),("sessionHeader","")])
        
        for section in FeedTableViewController.sections() {
            let count = Ticket.countForSection(self.moc, section: section)
            
            if count > 0 {
                rows.append(( "session",section))
            }
            
            
        }
        
        // ("userHeader","Daren David Taylor"),("userSwipe",""),("alertHeader",""),("alert","Well done you did one week."),("alert","Would you like to review the app."),("alert","Your friend is following you"),
        
        
        
        rows.append(contentsOf: [("archiveHeader","")])
        
        for section in Ticket.sections(self.moc) {
            if !FeedTableViewController.sections().contains(section) {
                rows.append(contentsOf: [("archiveSession",section)])
            }
        }
        rows.append(contentsOf: [("preferencesHeader",""),("preferences","")])
        
        //    rows.append(contentsOf: [("archiveHeader",""),("archiveSession","Friday Morning 23rd October"),("archiveSession","Friday Afternoon 23rd October"),("archiveSession","Saturday Afternoon 24rd October"),("preferencesHeader",""),("preferences",""),("companyDetails","") ])
        
        return rows
    }
    
    func heightWithIdentifier(identifier:String) -> CGFloat {
        let tupleArray =  [("userHeader",60),("userSwipe",110),("alertHeader",50),("alert",80),("createHeader",50),("createSwipe",80),("sessionHeader",50),("session",50),("archiveHeader",50),("archiveSession",50),("preferencesHeader",50),("preferences",100),("companyDetails",100) ]
        
        for item in tupleArray {
            if item.0 == identifier {
                return CGFloat(item.1)
            }
        }
        
        return CGFloat(0)
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.data()[indexPath.row]
        
        let identifier = item.0
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        switch(item.0)
        {
        case "userHeader":
            let cell = cell as! UserHeaderTableViewCell
            cell.setupWith(name: item.1)
        case "alert":
            let cell = cell as! AlertTableViewCell
            cell.setupWith(title: item.1)
        case "createSwipe":
            let cell = cell as! CreateSwipeTableViewCell
            cell.setupWith(delegate:self)
        case "session":
            let cell = cell as! SessionTableViewCell
            cell.setupWith(name:item.1)
        case "archiveSession":
            let cell = cell as! SessionTableViewCell
            cell.setupWith(name:item.1)
        case "preferences":
            let cell = cell as! PreferencesSwipeTableViewCell
            cell.setupWith(delegate:self)
        default:
            break
        }
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data().count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let identifier = self.data()[indexPath.row].0
        return self.heightWithIdentifier(identifier: identifier)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.data()[indexPath.row].0 {
        case "alert":
            let storyboard = UIStoryboard(name: "Alert", bundle: nil)
            let vc = storyboard.instantiateInitialViewController() as! AlertViewController
            
            vc.setupWith(alert: Alert.all(self.moc)[0], delegate: self)
            
            vc.modalTransitionStyle = .crossDissolve
            
            self.present(vc, animated: true, completion: nil)
            
        case "session":
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nc = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
            let vc = nc.viewControllers[0] as! BoardTableViewController
            vc.section = self.data()[indexPath.row].1
            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated:(self.navigationController?.navigationBar.isHidden)!)
        case "archiveSession":
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nc = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
            let vc = nc.viewControllers[0] as! BoardTableViewController
            vc.section = self.data()[indexPath.row].1
            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated:(self.navigationController?.navigationBar.isHidden)!)
        default:
            break
        }
    }
}

extension FeedTableViewController : CreateSwipeTableViewCellDelegate
{
    func createIn(section:String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nc = storyboard.instantiateViewController(withIdentifier: "TicketNavigationViewController") as! UINavigationController
        let vc = nc.viewControllers[0] as! TicketViewController
        vc.newTicket = true
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? UserHeaderTableViewCell {
            var size = 24 + -scrollView.contentOffset.y/40
            print(size)
            if size < 24 {
                size = 24
            }
            cell.nameLabel.font =  UIFont(name: "Helvetica Neue", size: size)
        }
    }
}

extension FeedTableViewController : TicketViewControllerDelegate {
    func ticketViewControllerSave(_ ticketViewController: TicketViewController) {
        self.dismiss(animated: true) {
            self.saveChildMoc()
            self.tableView.reloadData()
        }
    }
    
    func ticketViewControllerCancel(_ ticketViewController: TicketViewController) {
        self.dismiss(animated: true) {
        }
    }
    func delete(ticket:Ticket) {
    }
}


extension FeedTableViewController : PreferencesSwipeTableViewCellDelegate
{
    func signOut() {
        self.dismiss(animated: true, completion: nil)
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "loggedInWithoutAuth")
        defaults.synchronize()
        SyncService.sharedInstance.removeAllForSignOut()
        try! Auth.auth().signOut()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.gotoLogin()
        appDelegate.signOut()
        
        
        
    }
    
    func registerForSync() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.gotoSignUp()
    }
}

extension FeedTableViewController : AlertViewControllerDelegate {
    func done() {
        
    }
}
