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
    let realm = OSTABManager.ostRealm()
    
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
    
    class func ostRealm() -> RLMRealm {
        // Switch return statements for in-memory vs. persisted Realms
        return RLMRealm.inMemoryRealmWithIdentifier("OSTABManagerRealm");
        //return RLMRealm.defaultRealm()
    }
    
    func addressBookDidChange(notification: NSNotification) {
        println("address book changed via notification: \(notification)")
        copyRecords(nil, failure: nil)
    }
    
    func hasPermission() -> Bool {
        return RHAddressBook.authorizationStatus() == RHAuthorizationStatus.Authorized
    }
    
    func copyRecords(success:(()->())?, failure:((message: String)->())?) {
        if hasPermission() {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                let backgroundRealm = OSTABManager.ostRealm()
                backgroundRealm.beginWriteTransaction()
                let people = self.ab.peopleOrderedByUsersPreference as! [RHPerson]
                for rhPerson in people {
                    self.writeRecord(realm: backgroundRealm, rhPerson: rhPerson)
                }
                backgroundRealm.commitWriteTransaction()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    success?()
                })
            })
        } else {
            failure?(message: "no permission")
        }
    }
    
    private func shouldSkip(rhPerson: RHPerson) -> Bool {
        let rhPhoneNumbers = rhPerson.phoneNumbers.values as Array?
        return (rhPerson.compositeName == nil || rhPhoneNumbers == nil)
    }
    
    private func writeRecord(#realm: RLMRealm, rhPerson: RHPerson) {
        if shouldSkip(rhPerson) {
            return;
        }
        
        let rhPhoneNumbers = rhPerson.phoneNumbers.values as Array?
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
        
        // TODO: Enforce that this happens in the expected thread and transaction
        OSTPerson.createOrUpdateInRealm(realm, withObject: ostPerson)
    }
    
    func requestAuthorization(completion:(isGranted: Bool, permissionError: NSError?)->()) {
        ab.requestAuthorizationWithCompletion { (granted, error) -> Void in
            completion(isGranted: granted, permissionError: error);
        }
    }
    
}
