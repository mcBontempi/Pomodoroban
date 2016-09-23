//
//  TicketTableViewCell.swift
//  Pomodoroban
//
//  Created by Daren David Taylor on 23/09/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    
    
    var ticket: Ticket? {
        didSet {
            self.titleLabel.text = ticket!.name
            
            
            self.showsReorderControl = true
            
        }
        
    }
}
