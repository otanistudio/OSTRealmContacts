//
//  OSTPhoneUtilityTests.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 4/19/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit
import XCTest

class OSTPhoneUtilityTests: XCTestCase {
    func testTranslation() {
        let sequence = "01ABCDEFGHIJKLMNOPQRSTUVWXYZ{-}+."
        let translated = OSTPhoneUtility.normalizedPhoneStringFromString(sequence)
        XCTAssertEqual("0122233344455566677778889999", translated)
    }
    
    func testNormalizedAmericanPhoneNumber() {
        let phoneNumber = "(555) 345-8713"
        let normalizedPhoneNumber = OSTPhoneUtility.normalizedPhoneStringFromString(phoneNumber)
        XCTAssertEqual("5553458713", normalizedPhoneNumber)
    }
    
    func testLetteredPhoneNumber() {
        let phoneNumber = "(888)555-WHAT"
        let normalizedPhone = OSTPhoneUtility.normalizedPhoneStringFromString(phoneNumber)
        XCTAssertEqual("8885559428", normalizedPhone)
    }
    
    func testWithCountryCode() {
        let phoneNumber = "+44(666)HUH-WHAT"
        let normalizedPhone = OSTPhoneUtility.normalizedPhoneStringFromString(phoneNumber)
        XCTAssertEqual("446664849428", normalizedPhone)
    }
}
