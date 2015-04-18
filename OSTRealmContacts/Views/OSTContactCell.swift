//
//  OSTContactCell.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 3/15/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit

class OSTContactCell: UITableViewCell {

    @IBOutlet weak var fullNameLabel: UILabel!
    static let cellID = "OSTContactCellIdentifer"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        fullNameLabel.text = ""
    }

}
