//
//  Services.swift
//
//  Created by Björn Gonzalez on 2020-03-17.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import Foundation

class Services: BaseService
{

    func getAllMatchTable(group: String, success: @escaping ((_ response: AnyObject?) -> Void), failure: @escaping ((_ error: NSError?) -> Void)) {
        var request = AlamofireRequestModal()
        request.method = .get
        request.headers = [
            "x-rapidapi-host": "heisenbug-champions-league-live-scores-v1.p.rapidapi.com",
            "x-rapidapi-key": "fda34fb689msh97f90514c209731p1ca386jsn8a7188c58f9c"
        ]
        request.path = "https://heisenbug-champions-league-live-scores-v1.p.rapidapi.com/api/championsleague/table?group=\(group)"
        callWebServiceAlamofire(request, success: success, failure: failure)
    }
    
    func getAllMatchResults(group: String, success: @escaping ((_ response: AnyObject?) -> Void), failure: @escaping ((_ error: NSError?) -> Void)) {
        var request = AlamofireRequestModal()
        request.method = .get
        request.headers = [
            "x-rapidapi-host": "heisenbug-champions-league-live-scores-v1.p.rapidapi.com",
            "x-rapidapi-key": "fda34fb689msh97f90514c209731p1ca386jsn8a7188c58f9c"
        ]
        request.path = "https://heisenbug-champions-league-live-scores-v1.p.rapidapi.com/api/championsleague?group=\(group)&matchday=1"
        callWebServiceAlamofire(request, success: success, failure: failure)
    }
    
    func getAllTopScrorer(success: @escaping ((_ response: AnyObject?) -> Void), failure: @escaping ((_ error: NSError?) -> Void)) {
        var request = AlamofireRequestModal()
        request.method = .get
        request.headers = [
            "x-rapidapi-host": "heisenbug-champions-league-live-scores-v1.p.rapidapi.com",
            "x-rapidapi-key": "fda34fb689msh97f90514c209731p1ca386jsn8a7188c58f9c"
        ]
        request.path = "https://heisenbug-champions-league-live-scores-v1.p.rapidapi.com/api/championsleague/table/scorers"

        callWebServiceAlamofire(request, success: success, failure: failure)
    }
    
    func getAllMatchStats(success: @escaping ((_ response: AnyObject?) -> Void), failure: @escaping ((_ error: NSError?) -> Void)) {
        var request = AlamofireRequestModal()
        request.method = .get
        request.headers = [
            "x-rapidapi-host": "heisenbug-champions-league-live-scores-v1.p.rapidapi.com",
            "x-rapidapi-key": "fda34fb689msh97f90514c209731p1ca386jsn8a7188c58f9c"
        ]
        request.path = "https://heisenbug-champions-league-live-scores-v1.p.rapidapi.com/api/championsleague/table/scorers"

        callWebServiceAlamofire(request, success: success, failure: failure)
    }
    
    func getSquad(teamName: String, success: @escaping ((_ response: AnyObject?) -> Void), failure: @escaping ((_ error: NSError?) -> Void)) {
        var request = AlamofireRequestModal()
        request.method = .get
        request.headers = [
            "x-rapidapi-host": "heisenbug-champions-league-live-scores-v1.p.rapidapi.com",
            "x-rapidapi-key": "fda34fb689msh97f90514c209731p1ca386jsn8a7188c58f9c"
        ]
        request.path = "https://heisenbug-champions-league-live-scores-v1.p.rapidapi.com/api/championsleague/players?team=\(teamName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        callWebServiceAlamofire(request, success: success, failure: failure)
    }

}
