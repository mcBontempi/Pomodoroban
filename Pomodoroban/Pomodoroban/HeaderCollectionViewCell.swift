//
//  HeaderCollectionViewCell.swift
//  Pomodoroban
//
//  Created by Daren taylor on 04/02/2016.x
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
 
  @IBOutlet weak var nameLabel: UILabel!
  
  var ticket: Ticket? {
    didSet {
      self.nameLabel.text = ticket!.name
      
    }
    
  }
  
}
