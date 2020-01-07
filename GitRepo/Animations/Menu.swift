//
//  Menu.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 02/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import Foundation
import UIKit

class SlideInAnimation : NSObject, UIViewControllerAnimatedTransitioning {
    
    //flag
    var isMenuOpen: Bool = false
    
    var dimView = UIView()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
       guard let toController = transitionContext.viewController(forKey: .to),
        let fromController = transitionContext.viewController(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView
        
        let finalWidth = toController.view.bounds.width * 0.8
        let finalHeight = toController.view.bounds.height
        
        if isMenuOpen {
            dimView.backgroundColor = .black
            dimView.alpha = 0.0
            containerView.addSubview(dimView)
            dimView.frame = containerView.bounds
            // Add menu view controller to container
            containerView.addSubview(toController.view)
            

            // put the frame off the screen
            toController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }
        // Move on screen
        let transform = {
            self.dimView.alpha = 0.5
            toController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }
        
        
        // Move back off screen
        let identity = {
            self.dimView.alpha = 0.0
            fromController.view.transform = .identity
        }
        
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        UIView.animate(withDuration: duration, animations: {
            self.isMenuOpen ? transform() : identity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
        
    }
    
    
    
    
}
