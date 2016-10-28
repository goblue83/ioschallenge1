//
//  CustomCell.swift
//  iOSChallenge
//
//  Created by Tom Weeks on 10/27/16.
//  Copyright © 2016 PSOne28. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var age: UILabel!
    @IBOutlet var view: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
