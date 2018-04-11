//
//  MicSpecTableViewCell.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 1/20/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import UIKit

class MicSpecTableViewCell: UITableViewCell {

    static let reuseIdentifier = "specCell"
    
    @IBOutlet weak var specDescriptionLabel: UILabel!
    @IBOutlet weak var specLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
