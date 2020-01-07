//
//  MenuViewController.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 02/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//
import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var userPageController: UserPageViewController? {
        return parent as? UserPageViewController
    }
    enum MenuCatgorty: Int {
        case signOut
        case profile
    }
    
    var menuCatgorysNames: [String] = [
    "Sign Out",
    "My Profile"
    ]
    
    var didTapMenu: ((MenuCatgorty)->Void)?
    var closeMenuCallback: ()->() = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
            case .began:
                break
            case .changed:
                let x = sender.translation(in: self.view).x
                let p = x / self.view.bounds.width
                userPageController?.menu.toggleMenu(with: p)
            case .ended, .failed, .cancelled:
                userPageController?.menu.finishAnimation()
            case .possible:
                break
            @unknown default:
                fatalError()
            }
    }

    @IBAction func closeMenu(_ sender: Any) {
        self.closeMenuCallback()
    }
    
}


extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuCatgorysNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = menuCatgorysNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          guard let menuType = MenuCatgorty.init(rawValue: indexPath.row) else {
                  return
                  
              }
              dismiss(animated: true) { [weak self] in
                  guard let self = self else { return }
                  self.didTapMenu?(menuType)
              }
    }
}
