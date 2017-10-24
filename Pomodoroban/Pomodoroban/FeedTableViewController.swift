import UIKit
import CoreData

class FeedTableViewController: UITableViewController {
    
    let moc = CoreDataServices.sharedInstance.moc
    var childMoc:NSManagedObjectContext!
    
    func data() -> [(String,String)]
    {
        return [("userHeader","Daren David Taylor"),("userSwipe",""),("alertHeader",""),("alert","Well done you did one week."),("alert","Would you like to review the app."),("alert","Your friend is following you"),("createHeader",""),("createSwipe",""),("sessionHeader",""),("session",""),("archiveHeader",""),("archive",""),("preferencesHeader",""),("preferences",""),("companyDetails","") ]
    }
    
    func heightWithIdentifier(identifier:String) -> CGFloat {
        let tupleArray =  [("userHeader",100),("userSwipe",110),("alertHeader",50),("alert",50),("createHeader",50),("createSwipe",80),("sessionHeader",70),("session",100),("archiveHeader",70),("archive",100),("preferencesHeader",70),("preferences",100),("companyDetails",100) ]
        
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
}


extension FeedTableViewController : CreateSwipeTableViewCellDelegate
{
    func addToBacklog() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nc = storyboard.instantiateViewController(withIdentifier: "TicketNavigationViewController") as! UINavigationController
        
        let vc = nc.viewControllers[0] as! TicketViewController
        
        vc.setFocusToName = true
        
        let row = Ticket.spareRowForSection(0, moc:self.moc)
        
        self.childMoc = CoreDataServices.sharedInstance.childMoc()
        vc.ticket = Ticket.createInMoc(self.childMoc)
        vc.ticket.name = ""
        vc.ticket.row = Int32(row)
        vc.ticket.section = Int32(0)
        vc.ticket.pomodoroEstimate = 1
        vc.ticket.colorIndex = 2
        
        vc.delegate = self
        
        self.present(nc, animated: true) {}
        
    }
}

extension FeedTableViewController : TicketViewControllerDelegate {
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

