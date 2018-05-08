//
//  cardShadow.swift
//  TaskForce
//
//  Created by Daniel Stahl on 2/11/18.
//  Copyright © 2018 Daniel Stahl. All rights reserved.
//

import UIKit
@IBDesignable

class cardShadow: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 4)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.18
        self.layer.masksToBounds = false
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}
