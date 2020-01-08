//
//  RequestAgent.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 31/12/2019.
//  Copyright © 2019 com.erez8. All rights reserved.
//

import Foundation


class RequestAgent {
    
    static let shared = RequestAgent()
    
    private let session = URLSession.shared
    
    private let url: URL = URL(string: "https://api.github.com")!
    
    
    func executeURLRequest<T:Codable> (with url: URL,
                                       jsonDecoder: JSONDecoder = JSONDecoder(),
                                       _ completionHandler: @escaping (Result<[T],NetworkError>) -> Void) {
        
        let urlRequest = URLRequest(url: url)
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        session.dataTask(with: urlRequest) { data, res, error in
            if let _ = error {
                completionHandler(.failure(.connection))
            }
            
            guard let data = data else { return }
            guard let response = res as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.badCredentials))
                return
            }
            
            do {
                let res = try jsonDecoder.decode([T].self, from: data)
                completionHandler(.success(res))
            } catch {
                completionHandler(.failure(.parse))
            }
        }.resume()
        
        
    }
    
    private func handleQuery(url: URLRequest, request: Requests) -> URLRequest? {
        guard let urlString = url.url?.absoluteString else { return nil }
                  var comp = URLComponents(string: urlString)
                  request.params.forEach{ (key, value) in
                      comp?.queryItems = [
                                     URLQueryItem(name: key, value: value)
                                 ]
                  }
        guard let compUrl = comp?.url else { return nil }
        return URLRequest(url: compUrl)
    }
    
    
    
    func executeRequest<T: Codable> (request: Requests,
                                     jsonDecoder: JSONDecoder = JSONDecoder(),
                                     completionHanlder: @escaping (Result<T,NetworkError>)->Void) {
        
        var urlCopy = url
        urlCopy.appendPathComponent(request.path.rawValue)
        var urlRequest = URLRequest(url: urlCopy)
        
        //set headers
        switch request.path {
        case .user:
            urlRequest.setValue("Basic \(request.auth)", forHTTPHeaderField: "Authorization")
            
        case .searchRepositories, .searchUsers:
            urlRequest.setValue("application", forHTTPHeaderField: "vnd.github.mercy-preview+json")
        
        }
        
        //set http method if post
        if request.httpMethod == .POST {
            urlRequest.httpMethod = "POST"
            
        }else{
            urlRequest.httpMethod = "GET"
            
        }
        
        if request.params.count > 0 {
            guard let urlRequestQuery = handleQuery(url: urlRequest, request: request) else { return }
            urlRequest = urlRequestQuery
        }
        
        //Fix "Failed to obtain sandbox extension"
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        
        session.dataTask(with: urlRequest) { data, res , error in
            if let _ = error  {
                
                completionHanlder(.failure(.connection))
                return
            }
            
            guard let data = data else { return }
            guard let response = res as? HTTPURLResponse, response.statusCode == 200 else {
                completionHanlder(.failure(.badCredentials))
                return
            }
            do {
                let res = try jsonDecoder.decode(T.self, from: data)
                completionHanlder(.success(res))
            } catch {
                print(error)
                completionHanlder(.failure(.parse))
            }
        }.resume()
        
    }
    
    
    
    
}


struct Requests {
    enum HttpMethods: String {
        case GET = "GET"
        case POST = "POST"
    }
    
    enum Path: String {
        case user
        case searchRepositories = "/search/repositories"
        case searchUsers = "/search/users"
    }
    
    var httpMethod: Requests.HttpMethods = .GET
    
    var path: Path
    var params: [String: String]
    var auth: String
    
    init(httpMethod: Requests.HttpMethods,
         params: [String:String] = [:],
         path: Path,
         auth : String = "") {
        
        self.httpMethod = httpMethod
        self.params = params
        self.path = path
        self.auth = auth
    }
    
    static func loginUser(username: String, password: String, _ callback :@escaping (Result<LoggedInUser,NetworkError>)->()) {
        
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        
        let request = Requests(httpMethod: .GET, path: .user, auth: base64LoginString)
        RequestAgent.shared.executeRequest(request: request) { res in
            callback(res)
        }
        
    }
      static func searchRepositories(searchTerm: String, _ callback: @escaping (Result<RepoSearch,NetworkError>)->()) {
        let request = Requests(httpMethod: .GET, params: ["q": searchTerm,
                                                          ], path: .searchRepositories)
        RequestAgent.shared.executeRequest(request: request) { res in
            callback(res)
        }
    }
    
    static func searchUsers(searchTerm: String, _ callback: @escaping (Result<UsersSearch,NetworkError>)->()) {
        let request = Requests(httpMethod: .GET, params: ["q": searchTerm,
                                                          ], path: .searchUsers)
        RequestAgent.shared.executeRequest(request: request) { res in
            callback(res)
        }
    }
    
}

enum NetworkError: Error {
    case connection
    case badCredentials
    case timeout
    case unknown
    case parse
    case generlError(message: String)
}
