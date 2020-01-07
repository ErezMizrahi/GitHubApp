//
//  Storyboarded.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 07/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiateFromMainStoryboard() -> Self
    static func instantiateFromUserPageStoryboard() -> Self
    static func instantiateFromSearchStoryboard() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiateFromMainStoryboard() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
    
    static func instantiateFromUserPageStoryboard() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "UserPage", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
    
    static func instantiateFromSearchStoryboard() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Search", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
