//
//  SearchViewController.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 06/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController, Storyboarded {
    @IBOutlet weak var searchContainerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    
    var originalDataSource: [Item] = []
    var currentDataSource: [Item] = []
    var bl: SearchVCBL!
    weak var flowManager: FlowManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableview()
        setupSearchController()
    }
    
    
    private func setupTableview() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSearchController() {
        self.bl = SearchVCBL()
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchContainerView.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
    }
    
    
    private func restoreToOriginalDataSource() {
        currentDataSource = originalDataSource
        tableView.reloadData()
    }
    
    
    @IBAction func typeOfSearchSegmentAction(_ sender: UISegmentedControl) {
        let searchType = SearchVCBL.TypeOfSearch(rawValue: sender.selectedSegmentIndex) ?? .repositories
        self.bl.searchType = searchType
    }
    
}



extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.showIndicatorInView()
        guard let search = searchBar.text else { return }
        self.bl.searchTerm = search
        
        switch bl.searchType {
        case .repositories:
            bl?.searchRepo() { items in
                DispatchQueue.main.async {
                    print(items)
                    switch items {
                    case let .failure(error):
                        print(error.localizedDescription)
                        self.view.removeIndicatorInView()
                    case let .success(items):
                        
                        self.originalDataSource = items
                        self.restoreToOriginalDataSource()
                        self.tableView.reloadData()
                        self.view.removeIndicatorInView()
                        
                    }
                }
            }
            
        case .users:
            bl?.searchUsers() { users in
                DispatchQueue.main.async {
                    print(users)
                    switch users {
                    case let .failure(error):
                        print(error.localizedDescription)
                        self.view.removeIndicatorInView()
                    case let .success(items):
                        self.originalDataSource = items
                        self.restoreToOriginalDataSource()
                        self.tableView.reloadData()
                        self.view.removeIndicatorInView()
                        
                    }
                }
            }
            
        }
        
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
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

