//
//  InstrumentCollectionViewCell.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 4/17/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import UIKit

class InstrumentCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "instrumentCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
    }
}
