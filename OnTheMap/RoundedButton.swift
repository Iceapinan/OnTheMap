//
//  RoundedButton.swift
//  OnTheMap
//
//  Created by IceApinan on 14/8/17.
//  Copyright © 2017 IceApinan. All rights reserved.
//

import UIKit


@IBDesignable class RoundedButton: UIButton {

    @IBInspectable var cornerRadius : CGFloat = 5.0 {
        didSet {
            return self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
    

}
