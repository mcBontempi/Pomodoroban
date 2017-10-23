
import UIKit

enum ESection {
    case user
    case alert
    case create
    case session
    case archive
    case preferences
}

enum EField {
    case userName
    case alertTitle
}

class FeedTableViewController: UITableViewController {

    func sections() ->  [ESection: [ [EField:String]  ]   ]  {
        
        return [
                        ESection.user:[[ EField.userName : "daren"]],
                        ESection.alert:[
                            [ EField.alertTitle : "Well pomodoroed you have done 5 days in a row."  ],
                            [ EField.alertTitle : "Have you thought about upgrading to Pomodoroban 3.0"  ]
                        ]
                     ]
    }

    func rowsForIndexPath(indexPath:IndexPath) ->  [ [ [EField:String]  ]
    {
        let section =
        
        return self.sections()[
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }


}
