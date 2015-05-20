//
//  QuestionStatViewController.swift
//  MovieGeekApp
//
//  Created by Dan Shevlyuk on 19/05/15.
//  Copyright (c) 2015 Pizza, Inc. All rights reserved.
//

import UIKit

class QuestionStatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var questionsTableView: UITableView!
    var questionList: [Question] = []
    var alertWithTextField: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionsTableView.dataSource = self
        self.questionsTableView.delegate = self
        updateData()
        
        self.alertWithTextField = UIAlertController(title: "Новый вопрос!", message: "Введите вопрос", preferredStyle: UIAlertControllerStyle.Alert)
        self.alertWithTextField!.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "???"
        })
        self.alertWithTextField!.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.Default, handler: nil))
        self.alertWithTextField!.addAction(UIAlertAction(title: "Готово!", style: UIAlertActionStyle.Default,
            handler: { (action) -> Void in
                let textField = self.alertWithTextField!.textFields![0] as! UITextField
                if textField.text != "" {
                    MovieGeekServerManager.sharedInstance.submitNewMovie(textField.text)
                }
        }))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateData()
        self.addButton.enabled = false
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
        
        
        MovieGeekServerManager.sharedInstance.getAllQuestions { (questionsList) -> Void in
            self.questionList = questionsList
            self.questionList.sort({$0.totalAnswers > $1.totalAnswers})
            indicator.stopAnimating()
            self.questionsTableView.reloadData()
            self.addButton.enabled = true
        }

    }
    
    @IBAction func addNewQuestion(sender: AnyObject) {
        if let alert = self.alertWithTextField {
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = questionsTableView.dequeueReusableCellWithIdentifier("questionCell") as! QuestionTableViewCell
        cell.questonTextLabel.text = questionList[indexPath.row].text
        cell.totalAnsTextLabel.text = String(questionList[indexPath.row].totalAnswers)
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.questionsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
