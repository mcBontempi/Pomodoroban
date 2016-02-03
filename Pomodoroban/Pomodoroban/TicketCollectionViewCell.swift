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
    }
  }
    
}
