
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userHeader")
        
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ESection.sectionCount.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }


}
