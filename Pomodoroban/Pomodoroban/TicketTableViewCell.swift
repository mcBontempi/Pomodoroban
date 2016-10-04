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
            self.titleLabel.textColor = UIColor.darkGrayColor()
          
            self.showsReorderControl = true
            
            if !self.isAddCell {
            self.contentView.layer.cornerRadius = 15
            self.contentView.clipsToBounds = true
            self.contentView.layer.borderColor = UIColor.redColor().CGColor
            self.contentView.layer.borderWidth = 6
            
            }
            else {
                self.contentView.layer.borderWidth = 0
                self.contentView.layer.backgroundColor = UIColor.whiteColor().CGColor
            }
        }
        
    }
    
    
    
    
    
}
