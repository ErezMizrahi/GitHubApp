//
//  ProfileImageView.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 02/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 25
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }

}
