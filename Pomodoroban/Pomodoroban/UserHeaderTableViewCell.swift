//
//  UserHeaderTableViewCell.swift
//  efficacious
//
//  Created by mcBontempi on 24/10/2017.
//  Copyright © 2017 LondonSwift. All rights reserved.
//

import UIKit

class UserHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWith(name:String) {
        self.nameLabel.text = name
    }


}
