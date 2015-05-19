//
//  QuestionTableViewCell.swift
//  MovieGeekApp
//
//  Created by Dan Shevlyuk on 19/05/15.
//  Copyright (c) 2015 Pizza, Inc. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questonTextLabel: UILabel!
    @IBOutlet weak var totalAnsTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
