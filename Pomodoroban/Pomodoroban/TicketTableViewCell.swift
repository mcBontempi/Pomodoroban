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
            
            self.backgroundColor = UIColor.colorFrom(Int( self.ticket!.colorIndex))
            
            self.showsReorderControl = true
            
            if !self.isAddCell {
            }
            else {
                self.backgroundColor = UIColor.whiteColor()
            }
        }
        
    }
 }
