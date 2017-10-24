
import UIKit

enum ESection : Int{
    case user = 0
    case alert
    case create
    case session
    case archive
    case preferences
    case sectionCount
}


class FeedTableViewController: UITableViewController {

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = ["userHeader","userSwipe","alertHeader","alert","createHeader","createSwipe","sessionHeader","session","archiveHeader","archive","preferencesHeader","preferences","companyDetails"][indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 13
        
    }


}
