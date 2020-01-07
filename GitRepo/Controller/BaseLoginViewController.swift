//
//  BaseLoginViewController.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 01/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit

class BaseLoginViewController: UIViewController {

    lazy var errorViewController: ErrorViewController? = {
          return children.compactMap { $0 as? ErrorViewController }.first
      }()
      
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func removeErrorVC() {
        if errorViewController == nil { return }
            removeAllChildren()
        
    }
    
    func removeAllChildren () {
        children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
