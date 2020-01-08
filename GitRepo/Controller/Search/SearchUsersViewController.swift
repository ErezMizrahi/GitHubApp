//
//  SearchUsersViewController.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 07/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import UIKit

class SearchUsersViewController: UIViewController, Storyboarded {
    
    enum Section {
        case main
    }
    
    var originalDataSource: [UserViewModel] = []
    var currentDataSource: [UserViewModel] = []
    weak var flowManager: FlowManager?
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, UserViewModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.collectionViewLayout = setLayout()
        collectionView.dataSource = dataSource
        dataSource = makeDataSource()
        
        collectionView.delegate = self
        updateDataSource(animated: true)
        
    }
    
    func setupDataSource(with item: [Item]) {
        originalDataSource = item.compactMap{$0 as? UserItem}.map{UserViewModel.init(user: $0)!}
        currentDataSource = originalDataSource
        updateDataSource(animated: true)
        
        collectionView.reloadData()
    }
    
    private func setLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, UserViewModel> {
        let reuseIdentifier = UserSearchCell.identifier
        
        return UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: {
            collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,for: indexPath) as! UserSearchCell
            
            cell.configure(with: item)
            
            return cell
        }
        )
        
    }
    
    
    func updateDataSource(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(currentDataSource)
        dataSource?.apply(snapshot, animatingDifferences: animated)
    }
    
    
}


extension SearchUsersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userModel = self.currentDataSource[indexPath.row]
        self.dismiss(animated: true) {
        self.flowManager?.instantiateUserPage(for: userModel)
        }
    }
}
