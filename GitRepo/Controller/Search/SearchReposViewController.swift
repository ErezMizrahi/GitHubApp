//
//  SearchRepos.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 07/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit

class SearchReposViewController: UIViewController, Storyboarded {
    var originalDataSource: [Item] = []
    var currentDataSource: [Item] = []
    weak var flowManager: FlowManager?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableview()
    }
    
    private func setupTableview() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
     func setupDataSource(with item: [Item]) {
        self.originalDataSource = item
          currentDataSource = originalDataSource
          tableView.reloadData()
      }
}

extension SearchReposViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //        let searchResult =
        if let searchResult = currentDataSource[indexPath.row] as? RepoItem {
            cell.textLabel?.text = searchResult.fullName
        } else if let searchResult = currentDataSource[indexPath.row] as? UserItem {
            cell.textLabel?.text = searchResult.login
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(currentDataSource[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        if let _ = currentDataSource[indexPath.row] as? RepoItem {
            print(currentDataSource[indexPath.row])
        } else if let searchResult = currentDataSource[indexPath.row] as? UserItem {
            self.dismiss(animated: true) {
                guard let user = UserViewModel(user: searchResult) else { return }
                self.flowManager?.instantiateUserPage(for: user)
            }
        }
    }
}


