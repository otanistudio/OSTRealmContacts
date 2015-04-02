//
//  OSTABManager.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 3/8/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit
import Realm

class OSTABManager {
    let ab = RHAddressBook()
    let realm = RLMRealm.inMemoryRealmWithIdentifier("OSTABManagerRealm")

    func hasPermission() -> Bool {
        return RHAddressBook.authorizationStatus() == RHAuthorizationStatus.Authorized
    }
    
    func copyRecords(success:()->(), failure:(message: String)->()) {
        if (self.hasPermission()) {
            let people = self.ab.peopleOrderedByUsersPreference as [RHPerson]
            for rhPerson in people {
                self.writeRecordWithPerson(rhPerson)
            }
            success()
        } else {
            failure(message: "no permission")
        }
    }
    
    private func writeRecordWithPerson(rhPerson: RHPerson) {
        weak var weakSelf = self;
        
        var ostPerson = OSTPerson()
        ostPerson.fullName = rhPerson.compositeName != nil ? rhPerson.compositeName : "n/a"
        ostPerson.firstName = rhPerson.firstName != nil ? rhPerson.firstName : ""
        ostPerson.lastName = rhPerson.lastName != nil ? rhPerson.lastName : ""
        
        realm.transactionWithBlock { () -> Void in
            self.realm.addObject(ostPerson)
        }
        
        let rhPhoneNumbers = rhPerson.phoneNumbers.values as Array?
        
        if rhPhoneNumbers == nil {
            return;
        }
        
        for rhNumber in rhPhoneNumbers! {
            let n: NSString! = rhNumber as NSString
            println(OSTPhoneUtility.normalizedPhoneStringFromString(n))
        }
    }
    
    func requestAuthorization(completion:(isGranted: Bool, permissionError: NSError?)->()) {
        ab.requestAuthorizationWithCompletion { (granted, error) -> Void in
            completion(isGranted: granted, permissionError: error);
        }
    }
    
}
