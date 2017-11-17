//
//  AutumnTableViewCell.swift
//  AutumnWorkspace
//
//  Created by Bùi Hà on 17/11/17.
//  Copyright © 2017 Thang Phan. All rights reserved.
//

import UIKit

class AutumnTableViewCell: UITableViewCell {

    @IBOutlet weak var autumnImageView: UIImageView!
    @IBOutlet weak var themeNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    var autumn: Autumn? {
        didSet {
            self.autumnImageView.image = autumn?.image
            self.themeNameLabel.text = autumn?.themeName
            self.themeNameLabel.numberOfLines = 0
            self.themeNameLabel.textColor = UIColor.white
            self.titleLabel.text = autumn?.titleText
            self.titleLabel.numberOfLines = 0
            self.titleLabel.textColor = UIColor.white
        }
    }
    
}
