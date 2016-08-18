//
//  MenuCell.swift
//  weatherTestApp
//
//  Created by iMac on 8/18/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
