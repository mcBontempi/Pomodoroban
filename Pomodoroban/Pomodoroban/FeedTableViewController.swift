import UIKit
import CoreData

class FeedTableViewController: UITableViewController {
    
    let moc = CoreDataServices.sharedInstance.moc
    var childMoc:NSManagedObjectContext!
    var lasty = CGFloat(0.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.navigationController!.redWithLogo()
        let imageView = UIImageView(image:UIImage(named:"Calchua"))
        
        imageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = imageView
        
        BuddyBuildSDK.setup()
        if Runtime.all(self.moc).count > 0 {
            
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "TimerViewController")
            
            self.present(vc, animated: false, completion: {
                
            })
            
        }
    }
    
    func data() -> [(String,String)]
    {
        var counts:[Int] = [Int]()
        for count in 0 ... 3 {
            counts.append(Ticket.countForSection(self.moc, section: ["Backlog","Morning","Afternoon","Evening"][count]))
        }
        var rows =  [("userHeader","Daren David Taylor"),("userSwipe",""),("alertHeader",""),("alert","Well done you did one week."),("alert","Would you like to review the app."),("alert","Your friend is following you"),("createHeader",""),("createSwipe",""),("sessionHeader","")]
        
        if counts[0] > 0 {
            rows.append(( "session","Backlog"))
        }
        if counts[1] > 0 {
            rows.append(( "session","Morning"))
        }
        if counts[2] > 0 {
            rows.append(( "session","Afternoon"))
        }
        if counts[3] > 0 {
            rows.append(( "session","Evening"))
        }
        
        rows.append(contentsOf: [("archiveHeader",""),("archiveSession","Friday Morning 23rd October"),("archiveSession","Friday Afternoon 23rd October"),("archiveSession","Saturday Afternoon 24rd October"),("preferencesHeader",""),("preferences",""),("companyDetails","") ])
        
        return rows
    }
    
    func heightWithIdentifier(identifier:String) -> CGFloat {
        let tupleArray =  [("userHeader",50),("userSwipe",110),("alertHeader",50),("alert",50),("createHeader",50),("createSwipe",80),("sessionHeader",50),("session",50),("archiveHeader",50),("archiveSession",50),("preferencesHeader",70),("preferences",100),("companyDetails",100) ]
        
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
            let vc = storyboard.instantiateInitialViewController()
            self.present(vc!, animated: true, completion: nil)
            
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
            var size = 26 + -scrollView.contentOffset.y/20
            print(size)
            if size < 26 {
                size = 26
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
    func delete() {
    }
}

