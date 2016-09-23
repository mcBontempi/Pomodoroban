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

    var isAddCell = true
    
    var ticket: Ticket? {
        didSet {
            self.titleLabel.text = ticket!.name
            
            
            self.showsReorderControl = true
            
            if !self.isAddCell {
            self.contentView.layer.cornerRadius = 4
            self.contentView.clipsToBounds = true
            self.contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.contentView.layer.borderWidth = 2
            self.contentView.layer.backgroundColor = UIColor.redColor().CGColor
            
            }
            else {
                self.contentView.layer.borderWidth = 0
                self.contentView.layer.backgroundColor = UIColor.whiteColor().CGColor
            }
        }
        
    }
    
    
    
}
