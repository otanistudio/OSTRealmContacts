//
//  OSTABManager.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 3/8/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit

class OSTABManager {
    let ab = RHAddressBook()

    func hasPermission() -> Bool {
        return RHAddressBook.authorizationStatus() == RHAuthorizationStatus.Authorized
    }
    
    func copyRecords(success:()->(), failure:()->()) {
        if (hasPermission()) {
            let people = ab.peopleOrderedByUsersPreference as [RHPerson]
            for rhPerson in people {
                self.writeRecordWithPerson(rhPerson)
            }
            success()
        } else {
            println("no permission")
            failure()
        }
    }
    
    private func writeRecordWithPerson(rhPerson: RHPerson) {
        weak var weakSelf = self;
        
        var ostPerson = OSTPerson()
        ostPerson.fullName = rhPerson.compositeName
        ostPerson.firstName = rhPerson.firstName
        ostPerson.lastName = rhPerson.lastName
        
        println("ostPerson: \(ostPerson.fullName)")

        
        let rhPhoneNumbers = rhPerson.phoneNumbers.values as Array
        
        for rhNumber in rhPhoneNumbers {
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
