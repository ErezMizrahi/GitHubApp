//
//  UserDefualtsStore.swift
//  GitRepo
//
//  Created by Erez Mizrahi on 07/01/2020.
//  Copyright © 2020 com.erez8. All rights reserved.
//

import Foundation

class UserDefualtsStore {
         private var userData : [String:Any]?{
             set{
                 UserDefaults.standard.set(newValue, forKey: "userData")
                 UserDefaults.standard.synchronize()
             }
             get{
                let str = UserDefaults.standard.string(forKey: "userData")
                return UserDefaults.standard.value(forKey: str ?? "no key") as? [String:Any]
             }
         }
         
     //
         var userLoggedIn: UserViewModel? {
             get {
                do {
                    guard let vm = userData?["userLoggedIn"] as? Data else { return nil }
                           let decoder = try JSONDecoder().decode(UserViewModel.self, from: vm)
                           return decoder
                       } catch {
                           print(error)

                       }
                return nil
             }
             set {
                 var userData = self.userData ?? [:]
                guard let data = newValue?.encode() else { return }
                userData["userLoggedIn"] = data
                 self.userData = userData
             }
         }
}
