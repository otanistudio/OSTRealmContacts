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
    
    let manager = OSTABManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.manager.hasPermission()) {
            self.loadContactsButton.enabled = true
        } else {
            self.manager.requestAuthorization { (isGranted, permissionError) -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if (isGranted) {
                        self.loadContactsButton.enabled = true
                    } else {
                        self.permissionNoticeLabel.hidden = false
                    }
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapLoadContactsButton(sender: AnyObject) {
        self.loadingIndicator.startAnimating()
        self.beginFetch()
    }
    
    private func beginFetch() {
        manager.copyRecords({ [weak self]() -> () in    
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self!.loadingIndicator.stopAnimating()
                    self!.showContacts()
                })
            }, failure: { [weak self](message: String) -> () in
                let failAlert = UIAlertController.init(title: "Permission Required", message: message, preferredStyle: .Alert)
                let alertAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default) { action -> Void in
                }
                failAlert.addAction(alertAction)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self!.loadingIndicator.stopAnimating()
                    self!.presentViewController(failAlert, animated: false) { completion -> Void in }
                })
        })
    }

    private func showContacts() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let contactViewController = mainStoryboard.instantiateViewControllerWithIdentifier("sidContactsViewController") as! UIViewController
        self.parentViewController?.showViewController(contactViewController, sender: self)
    }

}

