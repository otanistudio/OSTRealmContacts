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
    dynamic var phoneNumber = ""
    
    override class func primaryKey() -> String {
        return "fullName"
    }
    
    init!(fullName: String, firstName: String, lastName: String, phoneNumber: String) {
        super.init()
        self.fullName = fullName
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
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
