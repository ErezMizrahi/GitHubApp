//
//  MainCoordinator.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 07/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import Foundation
import UIKit

class FlowManager: Coordinator {
    
    
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    var userDefualtsStore = UserDefualtsStore()
    
    var mainUser: UserViewModel? {
        didSet {
            userDefualtsStore.userLoggedIn = mainUser
        }
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
    }
    
    
    func start() {
        let loginVC = LoginViewController.instantiateFromMainStoryboard()
        loginVC.flowManager = self
        self.navigationController.navigationBar.isHidden = true
        self.navigationController.pushViewController(loginVC, animated: true)
    }
    
    func signOut() {
        mainUser = nil
        self.navigationController.popToRootViewController(animated: true)
    }
    
    
    func instantiateUserPage(for user: UserViewModel?) {
        let userPageVC = UserPageViewController.instantiateFromUserPageStoryboard()
        
        if let user = user {
            userPageVC.user = user
        } else {
            userPageVC.user = mainUser

        }
        
        userPageVC.flowManager = self
        self.navigationController.navigationBar.isHidden = false
        self.navigationController.pushViewController(userPageVC, animated: true)
    }
    
    
    
    func instantiateSearchPage() {
        let searchVC = SearchViewController.instantiateFromSearchStoryboard()
        searchVC.flowManager = self
        
        self.navigationController.navigationBar.isHidden = false
        self.navigationController.pushViewController(searchVC, animated: true)
    }
    
    
}
