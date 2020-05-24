//
//  UserDefaults+Extensions.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-03-26.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func saveIDToken(userID: String?) {
        if let id = userID {
            UserDefaults.standard.set(id, forKey: "userid_token")
        } else {
            UserDefaults.standard.removeObject(forKey: "userid_token")
        }
        UserDefaults.standard.synchronize()
    }
    
    func getIDToken() -> String? {
        return UserDefaults.standard.value(forKey: "userid_token") as? String
    }
    
    func saveFavrioteList(favList: [Int]?) {
        if let id = favList {
            UserDefaults.standard.set(id, forKey: "fav")
        } else {
            UserDefaults.standard.removeObject(forKey: "fav")
        }
        UserDefaults.standard.synchronize()
    }
    
    func getFavList() -> [Int]? {
        return UserDefaults.standard.value(forKey: "fav") as? [Int]
    }
    
}
