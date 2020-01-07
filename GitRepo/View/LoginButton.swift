//
//  LoginButton.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 26/12/2019.
//  Copyright © 2019 com.erez8. All rights reserved.
//

import UIKit

class LoginButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        self.addShadowToView()
    }
    
    

}


