//
//  localized.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 02/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import Foundation
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
