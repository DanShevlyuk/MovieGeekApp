//
//  MovieChooseViewController.swift
//  MovieGeekApp
//
//  Created by Dan Shevlyuk on 19/05/15.
//  Copyright (c) 2015 Pizza, Inc. All rights reserved.
//

import UIKit

class MovieChooseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var moviesTableView: UITableView!
    var movieList: [Movie] = []
    var alertWithTextField: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.reloadData()
        self.alertWithTextField = UIAlertController(title: "Новый фильм!", message: "Введите название фильма", preferredStyle: UIAlertControllerStyle.Alert)
        self.alertWithTextField!.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Название фильма"
        })
        self.alertWithTextField!.addAction(UIAlertAction(title: "Отмена", style: .Default, handler: nil))
        self.alertWithTextField!.addAction(UIAlertAction(title: "Готово!", style: .Default,
            handler: { (action) -> Void in
                let textField = self.alertWithTextField!.textFields![0] as! UITextField
                if textField.text != "" {
                    MovieGeekServerManager.sharedInstance.submitNewMovie(textField.text)
                }
        }))

    }
    
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCellWithIdentifier("movieCell") as! UITableViewCell
        cell.textLabel?.text = movieList[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        MovieGeekServerManager.sharedInstance.submitAnswer(movie: self.movieList[indexPath.row]) { (error) -> Void in
            println(error)
        }
        performSegueWithIdentifier("MovieChooseToEndGame", sender: nil)
    }
    @IBAction func addButtonPush(sender: AnyObject) {
        if let alert = self.alertWithTextField {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
