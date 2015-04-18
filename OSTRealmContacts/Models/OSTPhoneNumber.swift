//
//  OSTPhoneNumber.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 4/18/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import Foundation
import Realm

class OSTPhoneNumber: RLMObject {
    dynamic var normalizedNumber: String = ""
    dynamic var formattedNumber: String = ""
    
    init!(normalizedNumber: String, formattedNumber: String) {
        super.init()
        self.normalizedNumber = normalizedNumber
        self.formattedNumber = formattedNumber
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
