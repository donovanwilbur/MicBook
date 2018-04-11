//
//  DesignableView.swift
//  Mic Book
//
//  Created by Donovan Wilbur on 1/17/18.
//  Copyright © 2018 DDub. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class DesignableView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowPath: CGPath = CGPath(rect: CGRect.zero, transform: nil) {
        didSet {
            self.layer.shadowPath = shadowPath
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }
}
