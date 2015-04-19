//
//  OSTResultCell.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 4/19/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit

class OSTResultCell: UITableViewCell {
    
    static let cellID = "ResultCell"
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        fullNameLabel.text = ""
        phoneLabel.text = ""
    }
    
}
