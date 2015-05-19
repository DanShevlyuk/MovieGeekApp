//
//  Question.swift
//  MovieGeekApp
//
//  Created by Dan Shevlyuk on 15/05/15.
//  Copyright (c) 2015 Pizza, Inc. All rights reserved.
//

import UIKit

enum QuestionTypes: String {
    case Common = "common"
    case Final = "final"
}

enum Answer: String {
    case Yes = "yes"
    case No = "no"
    case IDunno = "idunno"
}

class Question: NSObject {
    var id: Int
    var text: String
    var totalAnswers: Int
    
    init(id: Int, text: String, totalAnswers: Int) {
        self.id = id
        self.text = text
        self.totalAnswers = totalAnswers
    }
    
    
    
}
