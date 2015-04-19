//
//  ViewController.swift
//  OSTRealmContacts
//
//  Created by Robert Otani on 3/8/15.
//  Copyright (c) 2015 Robert Otani. All rights reserved.
//

import UIKit

class OSTStartViewController: UIViewController {

    @IBOutlet weak var loadContactsButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var permissionNoticeLabel: UILabel!
    
    var manager = OSTABManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func checkPermission() {
        if manager.hasPermission() {
            loadContactsButton.enabled = true
        } else {
            manager.requestAuthorization { [weak self](isGranted, permissionError) -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if isGranted {
                        self?.loadContactsButton.enabled = true
                    } else {
                        self?.permissionNoticeLabel.hidden = false
                    }
                })
            }
        }
    }

    @IBAction func didTapLoadContactsButton(sender: AnyObject) {
        loadingIndicator.startAnimating()
        beginFetch()
    }
    
    private func beginFetch() {
        manager.copyRecords({ [weak self]() -> () in    
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.loadingIndicator.stopAnimating()
                    self?.showContacts()
                })
            }, failure: { [weak self](message: String) -> () in
                let failAlert = UIAlertController.init(title: "Permission Required", message: message, preferredStyle: .Alert)
                let alertAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default) { action -> Void in
                    self?.manager = nil
                    self?.manager = OSTABManager()
                    self?.checkPermission()
                }
                failAlert.addAction(alertAction)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.loadingIndicator.stopAnimating()
                    self?.presentViewController(failAlert, animated: false) { completion -> Void in }
                })
        })
    }

    private func showContacts() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let contactViewController = mainStoryboard.instantiateViewControllerWithIdentifier("sidContactsViewController") as! UIViewController
        parentViewController?.showViewController(contactViewController, sender: self)
    }

}

