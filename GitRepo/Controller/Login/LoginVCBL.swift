//
//  LoginVCBL.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 02/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import Foundation

struct LoginVCBL {
    var username: String = ""
    var password: String = ""
    
    enum ResponseFromServer<T:Codable> {
           case success(T)
           case failure(NetworkError)
       }
    
      func authUser( _ completionHandler: @escaping (ResponseFromServer<LoggedInUser>)->()) {
        Requests.loginUser(username: username, password: password) { res in
                  switch res {
                  case .failure(let error):
                    completionHandler(.failure(error))
                 
                  case .success(let result):
                    completionHandler(.success(result))
                  }

              }
    }
}
