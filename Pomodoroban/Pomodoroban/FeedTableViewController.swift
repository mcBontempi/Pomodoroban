import UIKit

class FeedTableViewController: UITableViewController {

    func data() -> [(String,String)]
    {
        return [("userHeader","Daren David Taylor"),("userSwipe",""),("alertHeader",""),("alert","Well done you did one week."),("alert","Would you like to review the app."),("alert","Your friend is following you"),("createHeader",""),("createSwipe",""),("sessionHeader",""),("session",""),("archiveHeader",""),("archive",""),("preferencesHeader",""),("preferences",""),("companyDetails","") ]
    }
  
    func heightWithIdentifier(identifier:String) -> CGFloat {
        let tupleArray =  [("userHeader",100),("userSwipe",110),("alertHeader",50),("alert",40),("createHeader",50),("createSwipe",100),("sessionHeader",70),("session",100),("archiveHeader",70),("archive",100),("preferencesHeader",70),("preferences",100),("companyDetails",100) ]
        
        for item in tupleArray {
            if item.0 == identifier {
                return CGFloat(item.1)
            }
        }
        
        return CGFloat(0)
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
