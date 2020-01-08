//
//  SearchVCBL.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 06/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import Foundation
struct SearchVCBL {
    var searchTerm: String = ""
    
    enum ResponseFromServer<T:Codable> {
        case success(T)
        case failure(NetworkError)
    }
    enum TypeOfSearch: Int {
         case repositories
         case users
     }
     
    var searchType: TypeOfSearch = .repositories
    
     func searchRepo(_ completionHandler: @escaping (ResponseFromServer<[RepoItem]>)->()) {
            Requests.searchRepositories(searchTerm: searchTerm) { res in
                      switch res {
                      case .failure(let error):
                          completionHandler(.failure(error))

                      case .success(let result):
                        completionHandler(.success(result.items))
                      }

        }
      
    }
    
     func searchUsers(_ completionHandler: @escaping (ResponseFromServer<[UserItem]>)->()) {
            Requests.searchUsers(searchTerm: searchTerm) { res in
                      switch res {
                      case .failure(let error):
                          completionHandler(.failure(error))
                          
                      case .success(let result):
                          completionHandler(.success(result.items))
                      }
                  
        }
    }
}
