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
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var dlabel: UILabel!

    @IBOutlet weak var pomodoroCountLabel: UILabel!
    var ticket: Ticket? {
        didSet {
            
            self.backgroundColor =  UIColor.colorFrom(Int( self.ticket!.colorIndex))
            
            self.titleLabel.text = ticket!.name! + ticket!.section + "\(ticket!.row)"
          //  self.titleLabel.textColor = UIColor.darkGray
            
            self.colorView.layer.cornerRadius = self.colorView.frame.size.width / 2
            
            self.colorView.layer.borderColor = UIColor.darkGray.cgColor
            self.colorView.layer.borderWidth = 2
            
            self.showsReorderControl = true
            
           self.colorView.backgroundColor = UIColor.white

            
            let count = self.ticket!.pomodoroEstimate
            
            self.pomodoroCountLabel.text = "\(count)"
            
            
        }
        
    }
}



