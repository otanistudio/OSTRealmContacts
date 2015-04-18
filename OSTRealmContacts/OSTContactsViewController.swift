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

    let realm = OSTABManager.realm()
    let people: RLMResults
    
    required init(coder aDecoder: NSCoder) {
        self.people = OSTPerson.allObjectsInRealm(OSTABManager.realm())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts via Realm"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let cell : OSTContactCell = tableView.dequeueReusableCellWithIdentifier("OSTContactCellIdentifer", forIndexPath: indexPath) as! OSTContactCell
        let ostPerson = people[UInt(indexPath.row)] as! OSTPerson
        cell.fullNameLabel.text = ostPerson.fullName as String

        return cell
    }
}
