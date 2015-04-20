//
//  OSTContactsViewController.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 3/15/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit
import Realm

class OSTContactsViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    let realm = OSTABManager.ostRealm()
    var realmNotification: RLMNotificationToken?
    var people: RLMResults
    
    var resultsTableController: OSTResultsTableController
    var searchController: UISearchController
    
    var searchControllerWasActive = false
    var searchControllerSearchFieldWasFirstResponder = false
    
    static let TitleKey = "ViewControllerTitleKey"
    static let SearchControllerIsActiveKey = "SearchControllerIsActiveKey"
    static let SearchBarTextKey = "SearchBarTextKey"
    static let SearchBarIsFirstResponderKey = "SearchBarIsFirstResponderKey"
    
    required init(coder aDecoder: NSCoder) {
        people = OSTPerson.allObjectsInRealm(realm).sortedResultsUsingProperty("fullName", ascending: true)
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // searchController state restoration
        if searchControllerWasActive {
            searchController.active = searchControllerWasActive
            searchControllerWasActive = false
            
            if searchControllerSearchFieldWasFirstResponder {
                searchController.searchBar.becomeFirstResponder()
                searchControllerSearchFieldWasFirstResponder = false
            }
        }
    }
    
    deinit {
        realm.removeNotification(realmNotification)
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
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UISearchResultsUpdating Protocol
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text as String
        
        if count(searchText) < 3 {
            return
        }
        
        let phonePredicate = NSPredicate(format: "normalizedNumber CONTAINS %@", argumentArray: [searchText])
        let phoneResults = OSTPhoneNumber.objectsInRealm(realm, withPredicate: phonePredicate)
        
        let searchPredicate = NSPredicate(format: "fullName CONTAINS[c] %@ OR ANY phoneNumbers IN %@", argumentArray: [searchText, phoneResults])
        let searchResults = OSTPerson.objectsInRealm(realm, withPredicate: searchPredicate)
        
        resultsTableController.foundPeople = searchResults
        resultsTableController.tableView.reloadData()
    }
    
    
    // MARK: - UIStateRestoration

    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        super.encodeRestorableStateWithCoder(coder)
        coder.encodeObject(title, forKey: OSTContactsViewController.TitleKey)
        
        let searchDisplayControllerIsActive: Bool = searchController.active
        coder.encodeBool(searchDisplayControllerIsActive, forKey: OSTContactsViewController.SearchControllerIsActiveKey)
        
        if searchDisplayControllerIsActive {
            coder.encodeBool(searchController.searchBar.isFirstResponder(), forKey: OSTContactsViewController.SearchBarIsFirstResponderKey)
        }
        
        coder.encodeObject(searchController.searchBar.text, forKey: OSTContactsViewController.SearchBarTextKey)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        super.decodeRestorableStateWithCoder(coder)
        title = coder.decodeObjectForKey(OSTContactsViewController.TitleKey) as? String
        searchControllerWasActive = coder.decodeBoolForKey(OSTContactsViewController.SearchControllerIsActiveKey)
        searchControllerSearchFieldWasFirstResponder = coder.decodeBoolForKey(OSTContactsViewController.SearchBarIsFirstResponderKey)
        searchController.searchBar.text = coder.decodeObjectForKey(OSTContactsViewController.SearchBarTextKey) as? String
    }

}
