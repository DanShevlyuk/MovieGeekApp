//
//  InfoViewController.swift
//  MovieGeekApp
//
//  Created by Dan Shevlyuk on 15/05/15.
//  Copyright (c) 2015 Pizza, Inc. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var textView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.layer.borderColor = UIColor.MGBlueColor().CGColor
        textView.layer.borderWidth = 3.0
        textView.layer.cornerRadius = 7
    }
}
