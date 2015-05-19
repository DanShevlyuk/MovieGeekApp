//
//  Movie.swift
//  MovieGeekApp
//
//  Created by Dan Shevlyuk on 15/05/15.
//  Copyright (c) 2015 Pizza, Inc. All rights reserved.
//

import UIKit

class Movie: NSObject {
    var id: Int
    var name: String
    var timesProposed: Int
    
    init(id: Int, name: String, timesProposed: Int) {
        self.id = id
        self.name = name
        self.timesProposed = timesProposed
    }
}
