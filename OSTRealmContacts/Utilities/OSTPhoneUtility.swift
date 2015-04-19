//
//  OSTPhoneUtility.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 3/15/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit

struct OSTPhone {
    static let lettersToNumString: [String: String] = [
        "A": "2",
        "B": "2",
        "C": "2",
        "D": "3",
        "E": "3",
        "F": "3",
        "G": "4",
        "H": "4",
        "I": "4",
        "J": "5",
        "K": "5",
        "L": "5",
        "M": "6",
        "N": "6",
        "O": "6",
        "P": "7",
        "Q": "7",
        "R": "7",
        "S": "7",
        "T": "8",
        "U": "8",
        "V": "8",
        "W": "9",
        "X": "9",
        "Y": "9",
        "Z": "9"
    ]
}

class OSTPhoneUtility: NSObject {
    class func normalizedPhoneStringFromString(phoneString: NSString?) -> NSString {
        let nonASCIICharacterSet = NSCharacterSet(charactersInString: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ").invertedSet
        var tmpSeparated = phoneString!.componentsSeparatedByCharactersInSet(nonASCIICharacterSet) as NSArray
        let immutablePhoneString = tmpSeparated.componentsJoinedByString("") as NSString
        var stringToFix = immutablePhoneString.mutableCopy() as! NSMutableString
        let range = NSMakeRange(0, stringToFix.length)
        for (letter, tone) in OSTPhone.lettersToNumString {
            stringToFix.replaceOccurrencesOfString(letter, withString: tone, options:.CaseInsensitiveSearch, range: range)
        }
        return stringToFix.copy() as! NSString
    }
    
}
