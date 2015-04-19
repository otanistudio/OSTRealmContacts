//
//  OSTContactsViewController.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 3/15/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit
import Realm

class OSTContactsViewController: UITableViewController {

    let realm = OSTABManager.ostRealm()
    var realmNotification: RLMNotificationToken?
    var people: RLMResults
    
    required init(coder aDecoder: NSCoder) {
        self.people = OSTPerson.allObjectsInRealm(realm).sortedResultsUsingProperty("fullName", ascending: true)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts via Realm"
        
        self.realmNotification = realm.addNotificationBlock({ [weak self](notificationString, realm) -> Void in
            self?.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(people.count)
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : OSTContactCell = tableView.dequeueReusableCellWithIdentifier(OSTContactCell.cellID, forIndexPath: indexPath) as! OSTContactCell
        let ostPerson = people[UInt(indexPath.row)] as! OSTPerson
        cell.fullNameLabel.text = ostPerson.fullName as String
        
        let ostPhone = ostPerson.phoneNumbers.firstObject() as! OSTPhoneNumber
        cell.phoneNumberLabel.text = ostPhone.formattedNumber
        return cell
    }
}
