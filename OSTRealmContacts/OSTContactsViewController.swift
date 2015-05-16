//
//  OSTContactsViewController.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 3/15/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit
import RealmSwift

class OSTContactsViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    let realm = OSTABManager.ostRealm()
    var realmNotification: NotificationToken?
    var people: Results<OSTPerson>
    
    var resultsTableController: OSTResultsTableController
    var searchController: UISearchController
    
    required init(coder aDecoder: NSCoder) {
        people = realm.objects(OSTPerson).sorted("fullName", ascending: true)
        resultsTableController = OSTResultsTableController()

        searchController = UISearchController(searchResultsController: resultsTableController)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts via Realm"
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        searchController.searchBar.sizeToFit()
        
        tableView.tableHeaderView = searchController.searchBar
        
        resultsTableController.tableView.delegate = self
        
        if realmNotification == nil {
            realmNotification = realm.addNotificationBlock({ [weak self](notificationString, realm) -> Void in
                self?.tableView.reloadData()
            })
        }
    }
    
    deinit {
        realm.removeNotification(realmNotification!)
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
        let ostPerson = people[indexPath.row] as OSTPerson
        cell.fullNameLabel.text = ostPerson.fullName as String

        let ostPhone = ostPerson.phoneNumbers.first
        let phoneString: String = ostPhone!.formattedNumber
        cell.configureCell(phoneString)
        return cell
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UISearchResultsUpdating Protocol
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as String
        
        if count(searchText) < 3 {
            return
        }
        let searchPredicate = NSPredicate(format: "fullName CONTAINS[c] %@ OR ANY phoneNumbers.normalizedNumber CONTAINS %@", searchText, searchText)
        let searchResults = realm.objects(OSTPerson).filter(searchPredicate)
        
        resultsTableController.foundPeople = searchResults
        resultsTableController.tableView.reloadData()
    }

}
