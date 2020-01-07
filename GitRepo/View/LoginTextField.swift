//
//  LoginTextField.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 26/12/2019.
//  Copyright © 2019 com.erez8. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.addShadowToView()
    }

}
