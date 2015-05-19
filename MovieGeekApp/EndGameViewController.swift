//
//  EndGameViewController.swift
//  MovieGeekApp
//
//  Created by Dan Shevlyuk on 19/05/15.
//  Copyright (c) 2015 Pizza, Inc. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)

    }
    @IBAction func closeButtonPush(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("Yay!")
        })
    }
}
