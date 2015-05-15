//
//  OSTPhoneNumber.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 4/18/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import Foundation
import RealmSwift

class OSTPhoneNumber: Object {
    dynamic var normalizedNumber: String = ""
    dynamic var formattedNumber: String = ""
    
    override class func primaryKey() -> String {
        return "normalizedNumber"
    }

}
