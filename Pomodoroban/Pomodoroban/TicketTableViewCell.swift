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
    var isAddCell = true
    
    @IBOutlet weak var dlabel: UILabel!
    @IBOutlet weak var pomodoroCountView: UIView!
    var ticket: Ticket? {
        didSet {
            self.titleLabel.text = ticket!.name
            self.titleLabel.textColor = UIColor.darkGrayColor()
            
            self.backgroundColor = UIColor.whiteColor()
       
            
            
            self.showsReorderControl = true
            for view in self.pomodoroCountView.subviews {
                view.removeFromSuperview()
            }
            
            if !self.isAddCell {
            
                
                self.colorView.backgroundColor = UIColor.colorFrom(Int( self.ticket!.colorIndex))
                
                
                let pomodoroView = UIView.pomodoroRowWith(Int(self.ticket!.pomodoroEstimate))
                
                self.pomodoroCountView.addSubview(pomodoroView)
            
            
            }
            else {
                self.colorView.backgroundColor = UIColor.whiteColor()
                self.backgroundColor = UIColor.whiteColor()
                
                
            }
        }
        
    }
 }
