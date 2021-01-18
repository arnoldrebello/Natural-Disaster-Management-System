//
//  TableViewCell.swift
//  Disaster Management
//
//  Created by Arnold Rebello on 6/8/20.
//  Copyright © 2020 Arnold Rebello. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsSource: UILabel!
    @IBOutlet weak var newsTitle: UILabel!

    func configureCell( newsTitle: String, newsSource: String) {
    //    self.newsImage.image = newsImage
        self.newsTitle.text = newsTitle
        self.newsSource.text = newsSource
    }
}
