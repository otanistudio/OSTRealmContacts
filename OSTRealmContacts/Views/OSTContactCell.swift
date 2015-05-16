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
    @IBOutlet weak var phoneNumberTextView: UITextView!
    
    static let cellID = "OSTContactCellIdentifer"
    
    internal func configureCell(text: String) {
        // Creating a new attributed string with the attributes we care about
        // does a better job at avoiding undesired state during cell reuse
        let paragraphStyle: AnyObject? = self.phoneNumberTextView.attributedText.attribute(NSParagraphStyleAttributeName, atIndex: 0, effectiveRange: nil)
        let fontAttr: AnyObject? = self.phoneNumberTextView.attributedText.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: nil)
        let attributes = [NSParagraphStyleAttributeName : paragraphStyle!, NSFontAttributeName: fontAttr!]
        
        self.phoneNumberTextView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
