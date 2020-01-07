//
//  UserPageViewController.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 01/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit
import SDWebImage

class UserPageViewController: UIViewController, Storyboarded {
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var menuOpen: NSLayoutConstraint!
 
    @IBOutlet weak var menuClose: NSLayoutConstraint!
    
    let menu = MenuManager()
    
    var user: UserViewModel? {
        didSet {
            if user?.bio?.count ?? 0 < 1 {
                self.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    weak var flowManager: FlowManager?

    
    var menuController: MenuViewController? {
        return children.compactMap{$0 as? MenuViewController}.first
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh(to: .close)
        self.title = user?.name
        
        menuController?.didTapMenu = { selection in
            switch selection {
            case .signOut:
                self.flowManager?.signOut()
            case .profile:
                self.flowManager?.instantiateUserPage(for: nil)
                break
            }
        }
        
        menuController?.closeMenuCallback = {
            self.menu.toogleMenu()
            
        }
        
        menu.callback = { state in
            self.refresh(to: state)
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let user = user else { return }
        
        if segue.identifier == "TopChildViewController" {
            let destVC = segue.destination as? TopChildViewController
            destVC?.user = user
        }
        
        if segue.identifier == "ReposViewController" {
            let destVC = segue.destination as? ReposViewController
            destVC?.user = user
        }
    }
    

    
    private func refresh(to state : MenuManager.MenuState){
        switch state {
        case .open:
            self.menuOpen.priority = .defaultHigh
            self.menuClose.priority = .defaultLow
        case .close:
            self.menuOpen.priority = .defaultLow
            self.menuClose.priority = .defaultHigh
        }
        
        
    }
    
    @IBAction func openSearchController(_ sender: Any) {
        flowManager?.instantiateSearchPage()
    }
    
    @IBAction func openMenu(_ sender: Any) {
        
        switch menu.state {
        case .open:
            menu.openMenu()
        case .close:
            menu.closeMenu()
        }
    }
    
    
}

