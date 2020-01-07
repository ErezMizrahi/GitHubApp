//
//  Extensions.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 01/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit

extension UIView {
    func quickErrorAlert(this error: NetworkError) -> UIAlertController {
        func buildController(title: String, message: String) -> UIAlertController {
              let alertController: UIAlertController = UIAlertController(title: title,
                                                                         message: message,
                                                                         preferredStyle: .alert)
              
              let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
              
              alertController.addAction(alertAction)
              return alertController
          }
        
        switch error {
        case .badCredentials:
            return buildController(title: "Ops... Wrong Details", message: "please try again with the correct credentials")
        default:
                        return buildController(title: "test", message: "test")

        }

  
    }
}
