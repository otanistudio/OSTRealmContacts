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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapLoadContactsButton(sender: AnyObject) {
        loadingIndicator.startAnimating()
        let manager = OSTABManager()
        
        weak var weakSelf = self
        if (manager.hasPermission()) {
            weakSelf!.beginFetch(manager)
        } else {
            manager.requestAuthorization({ (isGranted, permissionError) -> () in
                if (isGranted) {
                    weakSelf!.beginFetch(manager)
                }
            })
        }
    }
    
    private func beginFetch(manager: OSTABManager) {
        weak var weakSelf = self
        manager.copyRecords({ () -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    weakSelf!.loadingIndicator.stopAnimating()
                    weakSelf!.showContacts()
                })
            }, failure: { () -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    weakSelf!.loadingIndicator.stopAnimating()
                })
        })
    }

    private func showContacts() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let contactViewController = mainStoryboard.instantiateViewControllerWithIdentifier("sidContactsViewController") as UIViewController
        self.parentViewController?.showViewController(contactViewController, sender: self)
    }

}

