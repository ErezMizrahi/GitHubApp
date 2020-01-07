//
//  ViewExtensions.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 26/12/2019.
//  Copyright © 2019 com.erez8. All rights reserved.
//

import UIKit

extension UIView {
    func addShadowToView() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
    }
    
    func showIndicatorInView(tint : UIColor = .white){
           removeIndicatorInView()
                    
         let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large

           activityIndicator.hidesWhenStopped = true
           activityIndicator.color = .black
           activityIndicator.translatesAutoresizingMaskIntoConstraints = false
              self.addSubview(activityIndicator)
           let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
                            self.addConstraint(xCenterConstraint)

                            let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
                            self.addConstraint(yCenterConstraint)
           
           activityIndicator.startAnimating()
           
       }
      
       
       func removeIndicatorInView(){
           subviews.compactMap{ $0 as? UIActivityIndicatorView}.forEach{ $0.removeFromSuperview()}
       }
}

extension UIButton{
    func showIndicatorView(tint : UIColor = .white){
        removeIndicatorView()
        
        self.isEnabled = false
        
      let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
           self.addSubview(activityIndicator)
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: activityIndicator, attribute: .leading, multiplier: 0.8, constant: -16)
                         self.addConstraint(xCenterConstraint)

                         let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
                         self.addConstraint(yCenterConstraint)
        
        activityIndicator.startAnimating()
        
    }
   
    
    func removeIndicatorView(){
        subviews.compactMap{ $0 as? UIActivityIndicatorView}.forEach{ $0.removeFromSuperview()}
        self.isEnabled = true
    }
}

