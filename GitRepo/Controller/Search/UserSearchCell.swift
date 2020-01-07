//
//  UserSearchCell.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 07/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit
import SDWebImage

class UserSearchCell: UICollectionViewCell, SelfConfigureCell {
    static var identifier: String = "cell"
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with dataSource: UserViewModel) {
        
        self.imageView.layer.cornerRadius = 15
        self.imageView.addShadowToView()
        self.username.text = dataSource.login
        guard let url = URL(string: dataSource.avaterURL) else { return }
        self.imageView.sd_setImage(with: url)
    }
    
    
}
