//
//  GameViewController.swift
//  MovieGeekApp
//
//  Created by Dan Shevlyuk on 09/05/15.
//  Copyright (c) 2015 Pizza, Inc. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var questionCardPlaceholder: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var idunnoButton: UIButton!
    var questionCardView = QuestionCardView()
    var currentQuestion: Question?
    
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.backgroundColor = UIColor.MGBlueColor()
        self.indicator.layer.cornerRadius = 10
        self.indicator.alpha = 0.7
        self.indicator.frame = CGRect(x: 0.0, y: 0.0, width: 55.0, height: 55.0)
        self.indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        self.yesButton.layer.cornerRadius = 10
        self.noButton.layer.cornerRadius = 10
        self.idunnoButton.layer.cornerRadius = 10
        
        questionCardView = QuestionCardView(frame: self.questionCardPlaceholder.frame)
        self.view.addSubview(questionCardView)
        questionCardView.layer.borderColor = UIColor.MGBlueColor().CGColor
        questionCardView.layer.borderWidth = 3.0
        println("\(self.currentQuestion?.text)")
        questionCardView.question.text = self.currentQuestion?.text
    }
    
    func moveQuestionCards(#nextQuestion: Question) {
        self.indicator.stopAnimating()
        var questionFrame = self.questionCardView.frame
        var a = (self.view.frame.width - questionFrame.width) / 2
        var nextCardView = QuestionCardView(frame: CGRect(x: questionFrame.origin.x + a + questionFrame.width,
                                                y: questionFrame.origin.y,
                                            width: questionFrame.width,
                                           height: questionFrame.height))
        nextCardView.layer.borderColor = UIColor.MGBlueColor().CGColor
        nextCardView.layer.borderWidth = 3.0
        nextCardView.question.text = nextQuestion.text
        self.currentQuestion = nextQuestion
        
        self.view.addSubview(nextCardView)
        self.indicator.bringSubviewToFront(self.view)
        
        UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            var newQuestionFrame = nextCardView.frame
            
            questionFrame.origin.x -= questionFrame.size.width + a
            newQuestionFrame.origin.x -= questionFrame.size.width + a
            
            self.questionCardView.frame = questionFrame
            nextCardView.frame = newQuestionFrame
            }) { (finished) -> Void in
                var oldQuestion = self.questionCardView
                self.questionCardView = nextCardView
                oldQuestion.hidden = true
        }
    }
    
    func finalQuestionAlert(movieList: [Movie]) {
        self.indicator.stopAnimating()
        var finalQuestionAlert = UIAlertController(title: "Я понял!", message: "Мне кажется вы загадывали \"\(movieList[0].name)\"", preferredStyle: UIAlertControllerStyle.Alert)
        finalQuestionAlert.addAction(UIAlertAction(title: "Да", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
            MovieGeekServerManager.sharedInstance.submitAnswer(movie: movieList[0], onFailure: { (error) -> Void in
                println(error)
            })
            self.performSegueWithIdentifier("gameToEndGame", sender: nil)
        }))
        finalQuestionAlert.addAction(UIAlertAction(title: "Нет", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("gameToMovieChoose", sender: movieList)
        }))
        
        self.presentViewController(finalQuestionAlert, animated: true, completion: nil)
    }
    
    func submitAnswerAndGetNextQuestion(question: Question, answer: Answer, type: QuestionTypes) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        MovieGeekServerManager.sharedInstance.submitAnswer(question: question, answer: answer, type: type,
            common: { (question) -> Void in
                self.moveQuestionCards(nextQuestion: question)
                self.enableButtons()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            },
            final: { (movieList) -> Void in
                self.finalQuestionAlert(movieList)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }) { (error) -> Void in
                self.showErrorMessage()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func showErrorMessage() {
        var alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так и игра сломалась", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
            self.closeButtonPush("hello world")
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func yesButtonPush(sender: AnyObject) {
        submitAnswerAndGetNextQuestion(currentQuestion!, answer: Answer.Yes, type: QuestionTypes.Common)
        self.disableButtons()
        self.indicator.bringSubviewToFront(self.view)
        self.indicator.startAnimating()
    }
    
    @IBAction func noButtonPush(sender: AnyObject) {
        submitAnswerAndGetNextQuestion(currentQuestion!, answer: Answer.No, type: QuestionTypes.Common)
        self.disableButtons()
        self.indicator.startAnimating()
        self.indicator.bringSubviewToFront(self.view)
    }
    
    @IBAction func idunnoButtonPush(sender: AnyObject) {
        submitAnswerAndGetNextQuestion(currentQuestion!, answer: Answer.IDunno, type: QuestionTypes.Common)
        self.disableButtons()
        self.indicator.startAnimating()
        self.indicator.bringSubviewToFront(self.view)
    }
    
    
    func disableButtons() {
        self.yesButton.enabled = false
        self.noButton.enabled = false
        self.idunnoButton.enabled = false
    }
    
    func enableButtons() {
        self.yesButton.enabled = true
        self.noButton.enabled = true
        self.idunnoButton.enabled = true
    }
    
    @IBAction func closeButtonPush(sender: AnyObject) {
        MovieGeekServerManager.sharedInstance.killCurrentGame()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let data = sender as? [Movie] {
            var viewController = segue.destinationViewController as! MovieChooseViewController
            viewController.movieList = data
        }
    }
}
