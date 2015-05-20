//
//  MoviesStatViewContoller.swift
//  MovieGeekApp
//
//  Created by Dan Shevlyuk on 15/05/15.
//  Copyright (c) 2015 Pizza, Inc. All rights reserved.
//

import UIKit

class MoviesStatViewContoller: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var moviesTableView: UITableView!
    var moviesList: [Movie] = []
    var alertWithTextField: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        updateData()
        
        self.alertWithTextField = UIAlertController(title: "Новый фильм!", message: "Введите название фильма", preferredStyle: UIAlertControllerStyle.Alert)
        self.alertWithTextField!.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Название фильма"
        })
        self.alertWithTextField!.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.Default, handler: nil))
        self.alertWithTextField!.addAction(UIAlertAction(title: "Готово", style: UIAlertActionStyle.Default,
            handler: { (action) -> Void in
                let textField = self.alertWithTextField!.textFields![0] as! UITextField
                if textField.text != "" {
                    MovieGeekServerManager.sharedInstance.submitNewMovie(textField.text)
                }
        }))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.addButton.enabled = false
        updateData()
    }
    
    func updateData() {
        var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        
        indicator.backgroundColor = UIColor.MGBlueColor()
        indicator.layer.cornerRadius = 10
        indicator.alpha = 0.7
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 55.0, height: 55.0)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubviewToFront(self.view)
        indicator.startAnimating()
        
        MovieGeekServerManager.sharedInstance.getAllMovies { (moviesList) -> Void in
            self.moviesList = moviesList
            self.moviesList.sort({$0.timesProposed > $1.timesProposed})
            indicator.stopAnimating()
            self.moviesTableView.reloadData()
            self.addButton.enabled = true
        }
    }
    
    @IBAction func addNewMovie(sender: AnyObject) {
        if let alert = self.alertWithTextField {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCellWithIdentifier("movieCell") as! MovieTableViewCell
        cell.movieNameLabel.text = moviesList[indexPath.row].name
        cell.movieStatLabel.text = String(moviesList[indexPath.row].timesProposed)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.moviesTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
