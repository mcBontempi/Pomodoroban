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
            
                self.layer.cornerRadius = 4
                self.clipsToBounds = true
                self.layer.borderColor = UIColor.lightGrayColor().CGColor
                self.layer.borderWidth = 2
            
        }
        
    }
}
