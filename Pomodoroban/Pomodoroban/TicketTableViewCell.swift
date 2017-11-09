//
//  TicketTableViewCell.swift
//  Pomodoroban
//
//  Created by Daren David Taylor on 23/09/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import UIKit

protocol TicketTableViewCellDelegate {
    func didSelectTicketWithIdentifier(identifier:String)
}

class TicketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkImageView: UIImageView!
    var delegate:TicketTableViewCellDelegate!
    
    var checked:Bool = false {
        didSet {
            self.updateCheckbox()
        }
    }
    
    @IBAction func didPressCheckbox(_ sender: Any) {
        
      
        self.checked = !self.checked
        
        self.updateCheckbox()
        self.delegate.didSelectTicketWithIdentifier(identifier: (self.ticket?.identifier)!)
        
    }
    
    func updateCheckbox() {
               self.checkImageView.image = self.checked ? UIImage(named:"checked") : UIImage(named:"unchecked")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateCheckbox()
   }
    
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var dlabel: UILabel!
    
    var showsCheckbox:Bool! {
        didSet {
            self.checkboxButton.isHidden = !showsCheckbox
            self.checkImageView.isHidden = !showsCheckbox
        }
    }

    @IBOutlet weak var pomodoroCountLabel: UILabel!
    
    
    
    
    var ticket: Ticket? {
        didSet {
            
            self.backgroundColor =  UIColor.colorFrom(Int( self.ticket!.colorIndex))
            
            self.titleLabel.text = ticket!.name! //+ ticket!.section + "\(ticket!.row)"
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



