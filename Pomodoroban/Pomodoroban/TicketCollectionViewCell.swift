//
//  TicketCollectionViewCell.swift
//  Pomodoroban
//
//  Created by Daren taylor on 30/01/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit

class TicketCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var nameLabel: UILabel!

  var ticket: Ticket? {
    didSet {
      self.nameLabel.text = ticket!.name
  
      if ticket?.name != "dummy" {
        
      
      self.layer.cornerRadius = 4
      self.clipsToBounds = true
      self.layer.borderColor = UIColor.lightGrayColor().CGColor
      self.layer.borderWidth = 2
      
      
      }
      else {
        self.layer.borderColor = UIColor.whiteColor().CGColor
        
      }
    
    
    }

  }
    
}
