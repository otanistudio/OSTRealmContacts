//
//  OSTPerson.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 3/15/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import Foundation
import Realm

class OSTPerson : RLMObject {
    dynamic var fullName = ""
    dynamic var firstName = ""
    dynamic var lastName = ""
    dynamic var phoneNumbers = RLMArray(objectClassName: OSTPhoneNumber.className())
    
    override class func primaryKey() -> String {
        return "fullName"
    }
    
    init!(fullName: String, firstName: String, lastName: String, phoneNumbers: RLMArray) {
        super.init()
        self.fullName = fullName
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumbers = phoneNumbers
    }
    
    override init() {
        super.init()
    }

    override init!(object value: AnyObject!, schema: RLMSchema!) {
        super.init(object: value, schema: schema)
    }
    
    override init!(object: AnyObject!) {
        super.init(object: object)
    }
    
    override init!(objectSchema schema: RLMObjectSchema!) {
        super.init(objectSchema: schema)
    }
}
