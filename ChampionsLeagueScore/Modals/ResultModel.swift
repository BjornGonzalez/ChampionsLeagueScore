//
//  ResultModel.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-03-20.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import Foundation

class ResultModel: Codable {
    let matches: [Groups]?
}

class Groups: Codable {
    let group: String?
    let referee: String?
    let team1: Team1?
    let team2: Team1?
    let time: String?
    let when: String?
}

class Team1: Codable {
    let firstHalfScore: Int?
    let teamName: String?
    let teamScore: Int?
}

// For getting tableData
class RecordsData: Codable {
    let records: [Records]?
}

class Records: Codable {
    let draw: Int?
    let goalsAgainst: Int?
    let goalsFor: Int?
    let loss: Int?
    let played: Int?
    let points: Int?
    let team: String?
    let win: Int?
}

// For top scorer
class ScorerData: Codable {
    let scorers: [TopScorer]?
}

class TopScorer: Codable {
    let playerName: String?
    let goals: Int?
    let penalties: Int?
}

// For Squad

class SquadData: Codable {
    let players: [Players]?
}

class Players: Codable {
    let playerName: String?
    let position: String?
    let age: Int?
}


extension ResultModel {
    static func getAllMatchTable(group: String, success: @escaping ((_ responseObject: RecordsData?) -> Void), failure: @escaping ((_ error: NSError?) -> Void)) {
        Services().getAllMatchTable(group: group, success: { (response) in
            if let responseObj = response, let data: RecordsData = self.parseJSON(data: responseObj) {
                success(data)
            }
        }, failure: { (error) in
            failure(error)
        })
    }
    
    static func getAllMatchResults(group: String, success: @escaping ((_ responseObject: ResultModel?) -> Void), failure: @escaping ((_ error: NSError?) -> Void)) {
        Services().getAllMatchResults(group: group, success: { (response) in
            if let responseObj = response, let data: ResultModel = self.parseJSON(data: responseObj) {
                success(data)
            }
        }, failure: { (error) in
            failure(error)
        })
    }
    
    static func getAllTopScrorer( success: @escaping ((_ responseObject: ScorerData?) -> Void), failure: @escaping ((_ error: NSError?) -> Void)) {
        Services().getAllTopScrorer( success: { (response) in
            if let responseObj = response, let data: ScorerData = self.parseJSON(data: responseObj) {
                success(data)
            }
        }, failure: { (error) in
            failure(error)
        })
    }
    
    static func getAllMatchStats( success: @escaping ((_ responseObject: ScorerData?) -> Void), failure: @escaping ((_ error: NSError?) -> Void)) {
        Services().getAllMatchStats( success: { (response) in
            if let responseObj = response, let data: ScorerData = self.parseJSON(data: responseObj) {
                success(data)
            }
        }, failure: { (error) in
            failure(error)
        })
    }
    
    static func getAllSquad(teamName: String, success: @escaping ((_ responseObject: SquadData?) -> Void), failure: @escaping ((_ error: NSError?) -> Void)) {
        Services().getSquad(teamName: teamName, success: { (response) in
            if let responseObj = response, let data: SquadData = self.parseJSON(data: responseObj) {
                success(data)
            }
        }, failure: { (error) in
            failure(error)
        })
    }
    
    
    static func parseJSON<T: Codable>(data: AnyObject) -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            return try jsonDecoder.decode(T.self, from: jsonData)
        } catch let error {
            print(error)
        }
        return nil
    }
}
