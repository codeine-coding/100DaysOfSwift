//
//  FlagButton.swift
//  Project2
//
//  Created by Allen Whearry on 2/27/19.
//  Copyright © 2019 Codeine Technologies LLC. All rights reserved.
//

import UIKit

class FlagButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        setImage(UIImage(named: "us"), for: .normal)
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
}
