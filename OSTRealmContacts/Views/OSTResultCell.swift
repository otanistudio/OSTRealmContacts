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
    @IBOutlet weak var phoneNumberTextView: UITextView!
    
    internal func configureCell(text: String) {
        // Creating a new attributed string with the attributes we care about
        // does a better job at avoiding undesired state during cell reuse
        let paragraphStyle: AnyObject? = self.phoneNumberTextView.attributedText.attribute(NSParagraphStyleAttributeName, atIndex: 0, effectiveRange: nil)
        let fontAttr: AnyObject? = self.phoneNumberTextView.attributedText.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil)
        let attributes = [NSParagraphStyleAttributeName : paragraphStyle!, NSFontAttributeName: fontAttr!]
        
        self.phoneNumberTextView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
