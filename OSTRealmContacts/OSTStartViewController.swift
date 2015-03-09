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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapLoadContactsButton(sender: AnyObject) {
        loadingIndicator.startAnimating()
        
        // do some address book loading here, then show the contacts when it's done.
        self.showContacts()
    }

    private func showContacts() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let contactViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ContactsViewController") as UIViewController
        var nav : UINavigationController = UINavigationController(rootViewController: contactViewController)
        self.showViewController(nav, sender: self)
    }
}

