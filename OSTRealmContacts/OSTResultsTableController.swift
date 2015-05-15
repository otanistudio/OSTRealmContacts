//
//  OSTResultsTableController.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 4/18/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit
import RealmSwift

class OSTResultsTableController: UITableViewController {
    var foundPeople: Results<OSTPerson>?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "OSTResultCell", bundle: nil), forCellReuseIdentifier: OSTResultCell.cellID)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if foundPeople == nil {
            return 0
        }
        return Int(foundPeople!.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: OSTResultCell = tableView.dequeueReusableCellWithIdentifier(OSTResultCell.cellID, forIndexPath: indexPath) as! OSTResultCell

        let ostPerson = foundPeople?[indexPath.row] as OSTPerson?
        cell.fullNameLabel.text = ostPerson?.fullName as String!
        
        let ostPhone = ostPerson?.phoneNumbers.first as OSTPhoneNumber!
        cell.phoneLabel.text = ostPhone.formattedNumber
        
        return cell
    }
}
