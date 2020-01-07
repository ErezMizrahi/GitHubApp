//
//  SearchViewController.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 06/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit

protocol RepoSearchDelegate: class {
    func didSearchedForRepo()
}

protocol UserSearchDelegate: class {
    func didSearchedForUser()
}

class SearchViewController: BaseViewController, Storyboarded {
    @IBOutlet weak var searchContainerView: UIView!
    
    @IBOutlet weak var listContrainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    
    var originalDataSource: [Item] = []
    var currentDataSource: [Item] = []
    var bl: SearchVCBL!
    weak var flowManager: FlowManager?
    
    weak var repoDelegate: RepoSearchDelegate?
    
    var repoSearchVC: SearchReposViewController? {
        return children.compactMap{$0 as? SearchReposViewController}.first
    }
    
    var userSearchVC: SearchUsersViewController? {
        return children.compactMap{$0 as? SearchUsersViewController}.first
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(children)
        setupSearchController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchReposViewController" {
            let _ = segue.destination as? SearchReposViewController
            //            destVC?.originalDataSource = self.originalDataSource
            //            destVC?.currentDataSource = self.currentDataSource
            //            destVC?.user = user
        }
        
        //        if segue.identifier == "ReposViewController" {
        //            let destVC = segue.destination as? ReposViewController
        //            destVC?.user = user
        //        }
    }
    
    
    private func setupSearchController() {
        self.bl = SearchVCBL()
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchContainerView.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
    }
    
    @discardableResult
    private func repoSearchChildVC() -> SearchReposViewController {
        removeAllChildren()
        let repoVC = SearchReposViewController.instantiateFromSearchStoryboard()
        repoVC.flowManager = flowManager
        self.addChild(repoVC)
        listContrainerView.addSubview(repoVC.view)
        repoVC.didMove(toParent: self)
        return repoVC
    }
    
    @discardableResult
    private func userSearchChildVC() -> SearchUsersViewController {
        removeAllChildren()
        
        let userSearch = SearchUsersViewController.instantiateFromSearchStoryboard()
        userSearch.flowManager = flowManager
        self.addChild(userSearch)
        listContrainerView.addSubview(userSearch.view)
        userSearch.didMove(toParent: self)
        return userSearch
    }
    
    
    
    @IBAction func typeOfSearchSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            repoSearchChildVC()
            let searchType = SearchVCBL.TypeOfSearch(rawValue: sender.selectedSegmentIndex) ?? .repositories
                 self.bl.searchType = searchType
        case 1:
            userSearchChildVC()
            let searchType = SearchVCBL.TypeOfSearch(rawValue: sender.selectedSegmentIndex) ?? .repositories
                 self.bl.searchType = searchType
        default:
            break
        }
        
     
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
                        self.repoSearchChildVC().setupDataSource(with: items)
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
                        self.userSearchChildVC().setupDataSource(with: items)
//                        self.originalDataSource = items
//                        self.tableView.reloadData()
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

