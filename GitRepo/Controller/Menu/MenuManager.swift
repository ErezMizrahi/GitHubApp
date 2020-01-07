//
//  MenuManager.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 07/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit

class MenuManager {

    var menuAnimatior: UIViewPropertyAnimator?
    var state: MenuState = .close

    var callback: (MenuState)->() = {_ in}
      enum MenuState {
          case open
          case close
          
          var opposite: MenuState {
              switch self {
              case .open:
                  return .close
              case .close:
                  return .open
                  
              }
          }
      }
      
      

    
        func closeMenu() {
            finishAnimation()
    //        self.state = .open
            toogleMenu()
        }
        
        func openMenu() {
            finishAnimation()
    //              self.state = .close
                  toogleMenu()
        }
        
         func toogleMenu() {
            self.menuAnimatior = nil
            setupAnimator(pause: false)
            menuAnimatior?.startAnimation()

        }
        
         func setupAnimator(pause : Bool){
            if menuAnimatior != nil{
                print("menu animator is not nil")
                return
            }
            
            let nextState = self.state.opposite
            let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1) { [weak self] in
                guard let self = self else { return }
                
                self.callback(nextState)
//                self.refresh(to: nextState)
//                self.view.layoutSubviews()
            }
            
            animator.addCompletion{ [weak self] _ in
                guard let self = self else { return }
                self.state = nextState
                self.menuAnimatior = nil
            }
            
            if pause { animator.pauseAnimation() }
            
            self.menuAnimatior = animator
        }
        
        func toggleMenu(with progress : CGFloat){
              setupAnimator(pause: true)
              menuAnimatior?.fractionComplete = progress
          }
        

        func finishAnimation () {
            self.menuAnimatior?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
        
}
