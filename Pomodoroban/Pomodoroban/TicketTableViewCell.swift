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
    @IBOutlet weak var pomodoroCountView: UIView!
    var ticket: Ticket? {
        didSet {
            
            self.contentView.backgroundColor = UIColor(hexString: "F8FAE1")
            
            self.titleLabel.text = ticket!.name
            self.titleLabel.textColor = UIColor.darkGray
            
            self.noteTextView.text = ticket!.desc
            
            self.backgroundColor = UIColor(hexString: "F8FAE1")
            
            
            
            self.showsReorderControl = true
            for view in self.pomodoroCountView.subviews {
                view.removeFromSuperview()
            }
            
            self.colorView.backgroundColor = UIColor.colorFrom(Int( self.ticket!.colorIndex))
            
            
            let pomodoroView = UIView.pomodoroRowWith(Int(self.ticket!.pomodoroEstimate))
            
            self.pomodoroCountView.addSubview(pomodoroView)
            
            
        }
        
    }
}



