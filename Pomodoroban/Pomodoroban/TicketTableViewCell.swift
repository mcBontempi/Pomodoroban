//
//  TicketTableViewCell.swift
//  Pomodoroban
//
//  Created by Daren David Taylor on 23/09/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var dlabel: UILabel!

    @IBOutlet weak var pomodoroCountLabel: UILabel!
    var ticket: Ticket? {
        didSet {
            
            self.contentView.backgroundColor = UIColor(hexString: "F8FAE1")
            
            self.titleLabel.text = ticket!.name
            self.titleLabel.textColor = UIColor.darkGray
            
            self.noteTextView.text = ticket!.desc
            
            self.backgroundColor = UIColor(hexString: "F8FAE1")
            
            self.showsReorderControl = true
   
            
            self.colorView.layer.borderColor = UIColor.colorFrom(Int( self.ticket!.colorIndex)).cgColor
            
            self.colorView.layer.cornerRadius = self.colorView.frame.size.width/2
    
            self.colorView.layer.borderWidth = 4
            
            let count = self.ticket!.pomodoroEstimate
            
            self.pomodoroCountLabel.text = "\(count)"
            
            
        }
        
    }
}



