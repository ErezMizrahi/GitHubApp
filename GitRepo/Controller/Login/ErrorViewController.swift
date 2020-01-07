//
//  ErrorViewController.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 01/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    class func createVC() -> ErrorViewController {
           return UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "LoginError") as! ErrorViewController
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    

    func showWarning(_ text: String) {
        self.label.text = text
        self.label.numberOfLines = 0
        self.label.lineBreakMode = .byWordWrapping
        self.label.textAlignment = .center
    }

}
