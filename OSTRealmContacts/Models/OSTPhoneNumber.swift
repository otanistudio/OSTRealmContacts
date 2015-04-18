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
    
    init!(normalizedNumber: String) {
        super.init()
        self.normalizedNumber = normalizedNumber
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
