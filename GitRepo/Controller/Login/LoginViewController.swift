//
//  ViewController.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 26/12/2019.
//  Copyright © 2019 com.erez8. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: BaseLoginViewController, Storyboarded {
    
    @IBOutlet weak var userNameTextFeild: LoginTextField!
    @IBOutlet weak var passwordTextFeild: LoginTextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    var bl: LoginVCBL?
    weak var flowManager: FlowManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setObservers()
        
    }
    
    private func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardEventsUp(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardEventsDown(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    func validateUserDetails() -> (username:String ,password:String)? {
        guard let username = userNameTextFeild.text, let password = passwordTextFeild.text else {
            self.view.layoutSubviews()
            return nil
            
        }
        return (username,password)
        
    }
    
    
    
    
    
    @IBAction func loginUser(_ sender: UIButton) {
        sender.showIndicatorView()
        guard let authDetails = self.validateUserDetails() else { return }
        bl = LoginVCBL(username: authDetails.username, password: authDetails.password)
        bl?.authUser() { res in
            DispatchQueue.main.async {
                switch res {
                case .failure(let error):
                    self.showError(with: error)
                    sender.removeIndicatorView()
                    
                case .success(let user):
                    sender.removeIndicatorView()
                    guard let user = UserViewModel(user: user) else { return }
                    self.flowManager?.mainUser = user
                    self.flowManager?.instantiateUserPage(for: user)
                }
            }
        }
    }
    
    
    @objc func handleKeyboardEventsUp(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                UIView.animate(withDuration: 0.3, animations: { self.view.layoutSubviews() })
                
            }
        }
    }
    
    @objc func handleKeyboardEventsDown(notification: NSNotification) {
        
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            UIView.animate(withDuration: 0.3, animations: { self.view.layoutSubviews() })
            
        }
    }
    
    private func errorChildVC() -> ErrorViewController {
        if let errorVC = self.errorViewController { return errorVC }
        removeAllChildren()
        
        let errorVC = ErrorViewController.createVC()
        self.addChild(errorVC)
        
        self.stackView.insertArrangedSubview(errorVC.view, at: stackView.arrangedSubviews.count)
        self.descLabel.isHidden = true
        errorVC.didMove(toParent: self)
        return errorVC
    }
    
    private func showError(with message: NetworkError) {
        switch message {
        case .badCredentials:
            errorChildVC().showWarning("Error.connection".localized)
        case .connection:
            errorChildVC().showWarning("Error.badCredentials".localized)
        default:
            errorChildVC().showWarning("")
        }
        
    }
    @IBAction func tapToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}

