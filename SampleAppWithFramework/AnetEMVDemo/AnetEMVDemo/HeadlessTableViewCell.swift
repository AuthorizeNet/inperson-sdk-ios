//
//  HeadlessTableViewCell.swift
//  AnetEMVSdk
//
//  Created by Manjappa, Chinthan on 8/24/18.
//  Copyright © 2018 Pankaj Taneja. All rights reserved.
//

import UIKit

class HeadlessTableViewCell: UITableViewCell {

    @IBOutlet weak internal var textField: UITextField!
    @IBOutlet weak internal var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
