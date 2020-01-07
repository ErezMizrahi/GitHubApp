//
//  TopChildViewController.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 02/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit

class TopChildViewController: UIViewController {
    @IBOutlet weak var userImage: UIImageView!
    
    var user: UserViewModel?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        
    }
    
    @IBOutlet weak var bioDescLabel: UILabel!
    
    private func setupView() {
        guard let user = user else {
            let vc = view.quickErrorAlert(this: .generlError(message: "TRY AGAIN"))
            self.present(vc, animated: true, completion: nil)
            return
        }
        
        guard let url = URL(string: user.avaterURL) else { return }
        self.userImage.sd_setImage(with: url)
        
        self.usernameLabel.text = user.login
        self.bioLabel.text = user.bio
        if self.bioLabel.text?.count ?? 0 < 1 { self.bioDescLabel.isHidden = true }
        self.locationLabel.text = user.location
        
    }
    
    
}
