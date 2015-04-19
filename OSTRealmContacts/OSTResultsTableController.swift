//
//  OSTResultsTableController.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 4/18/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit
import Realm

class OSTResultsTableController: UITableViewController {
    var foundPeople: RLMResults?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let foundPeopleCount = Int(foundPeople!.count)
//        println("number of found people: \(foundPeopleCount)")
        if foundPeople == nil {
            return 0
        }
        return Int(foundPeople!.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: OSTContactCell = tableView.dequeueReusableCellWithIdentifier(OSTContactCell.cellID, forIndexPath: indexPath) as! OSTContactCell
        let ostPerson = foundPeople?[UInt(indexPath.row)] as! OSTPerson
        cell.fullNameLabel.text = ostPerson.fullName as String
        
        let ostPhone = ostPerson.phoneNumbers.firstObject() as! OSTPhoneNumber
        cell.phoneNumberLabel.text = ostPhone.formattedNumber
        
        return cell
    }
}
