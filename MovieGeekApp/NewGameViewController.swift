//
//  ViewController.swift
//  MovieGeekApp
//
//  Created by Dan Shevlyuk on 07/05/15.
//  Copyright (c) 2015 Pizza, Inc. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController {

    @IBOutlet weak var newGameButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newGameButton.layer.cornerRadius = 10
    }

    @IBAction func startNewGameTouch(sender: AnyObject) {
        var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        indicator.backgroundColor = UIColor.MGBlueColor()
        indicator.layer.cornerRadius = 10
        indicator.alpha = 0.7
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 55.0, height: 55.0)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        indicator.startAnimating()
        
        MovieGeekServerManager.sharedInstance.startNewGame({ (question) -> Void in
                indicator.stopAnimating()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.performSegueWithIdentifier("gameTabToGame", sender: question)
            }, onFailure: { (error) -> Void in
                self.showErrorMessage()
                indicator.stopAnimating()
        })
    }
    
    func showErrorMessage() {
        var alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так. Попробуйте позже.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ладно", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let question: Question = sender as? Question {
            let navController = segue.destinationViewController as! UINavigationController
            var gameView: GameViewController = navController.viewControllers[0] as! GameViewController
            gameView.currentQuestion = question
        }
    }

}

