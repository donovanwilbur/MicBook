//
//  HomeScreenCollectionViewCell.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 1/17/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import UIKit

class HomeScreenCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "homeScreenCell"
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(with homeScreenCard: HomeScreenCard) {
        mainImageView.image = homeScreenCard.image
        titleLabel.text = homeScreenCard.title
    }
    
}
