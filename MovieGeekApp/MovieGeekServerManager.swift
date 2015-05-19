//
//  MovieGeekServerManager.swift
//  MovieGeekApp
//
//  Created by Dan Shevlyuk on 10/05/15.
//  Copyright (c) 2015 Pizza, Inc. All rights reserved.
//

import UIKit
import Alamofire

class MovieGeekServerManager: NSObject {
    
    static let sharedInstance: MovieGeekServerManager = MovieGeekServerManager()
//    let baseUrl = "http://188.226.233.9/api/v1.0/"
    let baseUrl = "http://127.0.0.1:5000/api/v1.0/"
    var currentGameID: String?
    
    func startNewGame(onSuccess: (question: Question) -> Void, onFailure: (error: NSError) -> Void) {
        Alamofire.request(.GET, "\(baseUrl)start_new_game/", parameters: nil)
        .validate()
            .responseJSON { (request: NSURLRequest, response: NSHTTPURLResponse?, json, error:NSError?) -> Void in
                if error == nil {
                    println(json)
                    if let gameID: String = json?.valueForKey("game_id") as? String,
                        questionType: String = json!.valueForKey("question_type") as? String,
                        questionID: Int = json?.valueForKey("question_id") as? Int,
                        questionText: String = json?.valueForKey("question") as? String {
                            if let type = QuestionTypes(rawValue: questionType) {
                                self.currentGameID = gameID
                                var question = Question(id: questionID, text: questionText, totalAnswers: 0)
                                println(question)
                                onSuccess(question: question)
                            }
                    }
                } else {
                    println(response)
                    println(json)
                    onFailure(error: error!)
                }
        }
    }
    
    func submitAnswer(#question: Question,
                        answer: Answer,
                          type: QuestionTypes,
                        common: (question: Question) -> Void,
                         final: (moviesList: [Movie]) -> Void,
                     onFailure: (error: NSError) -> Void) {
                        
        if let gameID = self.currentGameID {
            let parameters = [
                "game_id" : gameID,
                "answer" : answer.rawValue,
                "question_type" : type.rawValue,
                "question_id" : question.id
            ]
            
            Alamofire.request(.POST, "\(baseUrl)submit_answer/", parameters: parameters as? [String : AnyObject], encoding: ParameterEncoding.JSON)
                .validate()
                .responseJSON { (request, response, json, error: NSError?) -> Void in
                    if error == nil {
                        println(json)
                        if let questionType: String = json!.valueForKey("question_type") as? String {
                            if let type = QuestionTypes(rawValue: questionType) {
                                self.currentGameID = gameID
                                
                                if type == QuestionTypes.Final {
                                    var moviesList: [Movie] = []
                                    var moviesDict = json?.valueForKey("movies") as! NSArray
                                    println(moviesDict)
                                    for m in moviesDict {
                                        if let id = m["id"] as? Int,
                                            name = m["name"] as? String,
                                            tP = m["times_proposed"] as? Int {
                                            
                                            var movie = Movie(id: id, name: name, timesProposed: tP)
                                            moviesList.append(movie)
                                        }
                                    }
                                    
                                    final(moviesList: moviesList)
                                } else if type == QuestionTypes.Common {
                                    let questionID: Int? = json?.valueForKey("question_id") as? Int
                                    let questionText: String? = json?.valueForKey("question") as? String
                                    var question = Question(id: questionID!, text: questionText!, totalAnswers: 0)
                                    common(question: question)
                                } else {
                                    onFailure(error: error!)
                                }
                            }
                        }
                    } else {
                        println(response)
                        println(json)
                        onFailure(error: error!)
                    }
            }
        }
    }
    
    
    func submitAnswer(#movie: Movie,
                   onFailure: (error: NSError) -> Void) {
            
            if let gameID = self.currentGameID {
                    let parameters = [
                        "game_id" : gameID,
                        "answer" : Answer.Yes.rawValue,
                        "question_type" : QuestionTypes.Final.rawValue,
                        "movie_id": movie.id]
                
                    Alamofire.request(.POST, "\(baseUrl)submit_answer/", parameters: parameters as? [String : AnyObject],
                                                                       encoding: ParameterEncoding.JSON)
            }
    }

    func getAllMovies(onSuccess: (moviesList: [Movie]) -> Void) {
        Alamofire.request(.GET, "\(baseUrl)get_all_movies/", parameters: nil)
            .responseJSON { (_, _, json, error: NSError?) -> Void in
                if error == nil {
                    var movies_list: [Movie] = []
                    var moviesDict = json?.valueForKey("movies") as! NSArray
                    for m in moviesDict {
                        if let id = m["id"] as? Int,
                               name = m["name"] as? String,
                            tP = m["times_proposed"] as? Int {
                                
                                var movie = Movie(id: id, name: name, timesProposed: tP)
                                movies_list.append(movie)
                        }
                    }
                    onSuccess(moviesList: movies_list)
                }
        }
        
    }
    
    func getAllQuestions(onSuccess: (questionsList: [Question]) -> Void) {
        Alamofire.request(.GET, "\(baseUrl)get_all_questions/", parameters: nil)
            .responseJSON { (_, _, json, error: NSError?) -> Void in
                if error == nil {
                    var questionsList: [Question] = []
                    var questionsDict = json?.valueForKey("questions") as! NSArray
                    for m in questionsDict {
                        if let id = m["id"] as? Int,
                            text = m["text"] as? String,
                            tA = m["total_answers"] as? Int {
                            
                                var question = Question(id: id, text: text, totalAnswers: tA)
                                questionsList.append(question)
                        }
                    }
                    onSuccess(questionsList: questionsList)
                }
        }
    }
    
    func killCurrentGame() {
        if let gameID = self.currentGameID {
            let parameters = ["game_id" : gameID]
            println(parameters)
            Alamofire.request(.DELETE, "\(baseUrl)kill_game/", parameters: parameters, encoding: ParameterEncoding.JSON)
                .validate()
        }
    }
    
    func submitNewQuestion(text: String) {
        let parameters = ["question" : text]
        Alamofire.request(.POST, "\(baseUrl)submit_new_question/", parameters: parameters, encoding: ParameterEncoding.JSON)
    }
    
    func submitNewMovie(name: String) {
        let parameters = ["movie" : name]
        Alamofire.request(.POST, "\(baseUrl)submit_new_movie/", parameters: parameters, encoding: ParameterEncoding.JSON)
    }
}