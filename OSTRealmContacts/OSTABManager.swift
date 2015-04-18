//
//  OSTABManager.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 3/8/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit
import Realm

class OSTABManager : NSObject, NilLiteralConvertible {
    var ab = RHAddressBook()
    
    required init(nilLiteral: ()) {
        super.init()
    }
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "addressBookDidChange:",
            name: RHAddressBookExternalChangeNotification,
            object: nil
        )
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    class func realm() -> RLMRealm {
        // Switch return statements for in-memory vs. persisted Realms
        return RLMRealm.inMemoryRealmWithIdentifier("OSTABManagerRealm");
        //return RLMRealm.defaultRealm()
    }
    
    func addressBookDidChange(notification: NSNotification) {
        println("address book changed via notification: \(notification)")
    }
    
    func hasPermission() -> Bool {
        return RHAddressBook.authorizationStatus() == RHAuthorizationStatus.Authorized
    }
    
    func copyRecords(success:()->(), failure:(message: String)->()) {
        if (self.hasPermission()) {
            let people = self.ab.peopleOrderedByUsersPreference as! [RHPerson]
            for rhPerson in people {
                self.writeRecordWithPerson(rhPerson)
            }
            success()
        } else {
            failure(message: "no permission")
        }
    }
    
    private func shouldSkip(rhPerson: RHPerson) -> Bool {
        return rhPerson.compositeName == nil
    }
    
    private func writeRecordWithPerson(rhPerson: RHPerson) {
        if (shouldSkip(rhPerson)) {
            return;
        }
        
        weak var weakSelf = self;
        
        let rhPhoneNumbers = rhPerson.phoneNumbers.values as Array?
        
        if rhPhoneNumbers == nil {
            return;
        }
        
        var rlmPhoneNumbers = RLMArray(objectClassName: OSTPhoneNumber.className())
        for rhNumber in rhPhoneNumbers! {
            let formattedNumString = rhNumber as! String
            let normalizedNumString = OSTPhoneUtility.normalizedPhoneStringFromString(formattedNumString) as String
            let phoneNumber = OSTPhoneNumber(normalizedNumber: normalizedNumString, formattedNumber: formattedNumString)
            rlmPhoneNumbers.addObject(phoneNumber)
        }
        
        var ostPerson = OSTPerson(
            fullName: rhPerson.compositeName,
            firstName: rhPerson.firstName != nil ? rhPerson.firstName : "",
            lastName: rhPerson.lastName != nil ? rhPerson.lastName : "",
            phoneNumbers: rlmPhoneNumbers
        )
        
        OSTABManager.realm().transactionWithBlock { () -> Void in
            var matches = OSTPerson.objectsWhere("fullName = '\(ostPerson.fullName)'")
            if (matches.count > 0) {
                println("\(ostPerson.fullName) already exists")
            } else {
                OSTABManager.realm().addObject(ostPerson)
            }
        }
    }
    
    func requestAuthorization(completion:(isGranted: Bool, permissionError: NSError?)->()) {
        ab?.requestAuthorizationWithCompletion { (granted, error) -> Void in
            completion(isGranted: granted, permissionError: error);
        }
    }
    
}
