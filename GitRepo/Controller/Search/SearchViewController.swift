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
        
        setupSearchController()
    }
    
    
    
    private func setupSearchController() {
        self.bl = SearchVCBL()
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchContainerView.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
        self.flowManager?.embedController(with: .repositories, of: self, into: self.listContrainerView)

    }
    
    
    @IBAction func typeOfSearchSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            let searchType = SearchVCBL.TypeOfSearch(rawValue: sender.selectedSegmentIndex) ?? .repositories
            self.bl.searchType = searchType
            self.flowManager?.embedController(with: searchType, of: self, into: self.listContrainerView)
        case 1:
            let searchType = SearchVCBL.TypeOfSearch(rawValue: sender.selectedSegmentIndex) ?? .repositories
            self.bl.searchType = searchType
            self.flowManager?.embedController(with: searchType, of: self, into: self.listContrainerView)
            
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
        
        switch self.bl.searchType {
        case .repositories:
            self.bl?.searchRepo() { items in
                switch items {
                case let .failure(error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.view.removeIndicatorInView()
                    }
                case let .success(items):
                    DispatchQueue.main.async {
                        self.repoSearchVC?.setupDataSource(with: items)
                        self.view.removeIndicatorInView()
                        
                    }
                }
            }
            
        case .users:
            self.bl?.searchUsers() { users in
                switch users {
                case let .failure(error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.view.removeIndicatorInView()
                    }
                case let .success(items):
                    DispatchQueue.main.async {
                        self.userSearchVC?.setupDataSource(with: items)
                        self.view.removeIndicatorInView()
                        
                    }
                }
            }
            
        }
    }
    
    
}




