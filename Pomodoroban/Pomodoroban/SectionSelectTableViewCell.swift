//
//  SectionSelectTableViewCell.swift
//  Pomodoroban
//
//  Created by mcBontempi on 26/04/2017.
//  Copyright © 2017 LondonSwift. All rights reserved.
//

import UIKit

class SectionSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var checkedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.checkedImageView.isHidden = !selected
    }

}
