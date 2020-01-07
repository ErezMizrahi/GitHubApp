//
//  ReposViewController.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 02/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit

class ReposViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var user: UserViewModel?

    var repos = [Repo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        getUserRepos()
    }
    

    private func getUserRepos() {
        guard let url = URL(string: user?.reposURL ?? "") else { return }
        self.view.showIndicatorInView()
        RequestAgent.shared.executeURLRequest(with: url) { (res:Result<[Repo],NetworkError>) in
            switch res {
            case .failure:
                DispatchQueue.main.async {
                                    self.view.removeIndicatorInView()
                }
            case .success(let result):
                DispatchQueue.main.async {
                    self.view.removeIndicatorInView()

                    self.repos = result
                    self.tableView.reloadData()
                }
            }
        }
    }

}



extension ReposViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.identifier , for: indexPath) as! RepoCell
        
        let repo = repos[indexPath.row]
        cell.configure(with: repo)
        
        return cell
    }
    
    
}



