//
//  OSTPerson.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 3/15/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import Foundation
import RealmSwift

class OSTPerson : Object {
    dynamic var fullName = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    
    dynamic var phoneNumbers = List<OSTPhoneNumber>()
    
    override class func primaryKey() -> String {
        return "fullName"
    }
}
