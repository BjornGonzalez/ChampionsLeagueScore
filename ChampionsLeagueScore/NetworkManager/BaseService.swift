//
//  BaseService.swift
//
//  Created by Björn Gonzalez on 2020-04-30.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

struct AlamofireRequestModal {
    var method: Alamofire.HTTPMethod
    var path: String
    var parameters: [String: AnyObject]?
    var headers: [String: String]?
    
    init() {
        method = .get
        path = ""
        parameters = nil
        headers = [ "Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest",
                    "Cache-Control": "no-cache" ]
    }
}

class BaseService: NSObject {
    
    func createNoNetworkConnectionView() {
        
    }
    
    func callWebServiceAlamofire(_ alamoReq: AlamofireRequestModal,
                                 success:@escaping ((_ responseObject: AnyObject?) -> Void),
                                 failure:@escaping ((_ error: NSError?) -> Void)) {
        
        if Reachability.sharedInstance.isReachable() {
            
            // Log path and parameters
            print("AlamoRequest:\npath: \(alamoReq.path)")
            print("\nparam: \(String(describing: alamoReq.parameters))")
            
            /*   Note:- Create alamofire request
             "alamoReq" is overridden in services, which will create a request here */
            
            let req = Alamofire.request(alamoReq.path, method: alamoReq.method, parameters: alamoReq.parameters, headers: alamoReq.headers)
            
            // Call response handler method of alamofire
            req.validate(statusCode: 200..<300).responseJSON(completionHandler: { (receivedInfo) in
                self.handleReceivedInfo(receivedInfo, success: success, failure: failure)
            })
        } else {
            createNoNetworkConnectionView()
            failure(nil)
        }
    }
    
    func callWebServiceAlamofire(infoData: Data,
                                 with fileName: String,
                                 alamoReq: AlamofireRequestModal,
                                 success:@escaping ((_ responseObject: AnyObject?) -> Void),
                                 failure:@escaping ((_ error: NSError?) -> Void)) {
        
        if Reachability.sharedInstance.isReachable() {
            // Log path and parameters
            print("AlamoRequest:\npath: \(alamoReq.path)")
            print("\nparam: \(String(describing: alamoReq.parameters))")
            
            var params = [String: String]()
            if let val = alamoReq.parameters as? [String: String] {
                params = val
            }
            
            // Call response handler method of alamofire
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                multipartFormData.append(infoData, withName: fileName, fileName: fileName + ".jpeg", mimeType: "image/jpeg")
                
                for (key, value) in params {
                    // Appending parameters in the request
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }
                
            }, to: alamoReq.path, method: alamoReq.method, headers: alamoReq.headers, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.validate(statusCode: 200..<300).responseJSON(completionHandler: { (receivedInfo) in
                        self.handleReceivedInfo(receivedInfo, success: success, failure: failure)
                    })
                case .failure(let encodingError):
                    print("error: \(encodingError.localizedDescription)")
                    failure(encodingError as NSError?)
                }
            })
            
        } else {
            createNoNetworkConnectionView()
        }
    }
    
    func handleReceivedInfo(_ receivedInfo: DataResponse<Any>,
                            success:@escaping ((_ responseObject: AnyObject?) -> Void),
                            failure:@escaping ((_ error: NSError?) -> Void)) {
        let statusCode = receivedInfo.response?.statusCode ?? 0
        switch receivedInfo.result {
        case .success(let data):
            print("\n Success: \(receivedInfo)")
            success(data as AnyObject?)
            
        case .failure(let error):
            print("\n Failure: \(error.localizedDescription)")
            
            var error = NSError.init(domain: "Error", code: statusCode, userInfo: nil)
            if let data = receivedInfo.data {
                do {
                    var responseObject: [String: AnyObject]?
                    if let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                        responseObject = response
                    }
                    error = NSError.init(domain: "Error", code: statusCode, userInfo: responseObject)
                } catch let error as NSError {
                    print("error: \(error.localizedDescription)")
                }
            }
            
            switch statusCode {
            case 401:
                //   loadErrorMessage(error: error)
                
                failure(error)
            case 500:
                //  showMessage(isSuccess: false, msg: "Server Error(500) \nSomething went wrong. Please try again!" )
                failure(error)
            default:
                //  loadErrorMessage(error: error)
                failure(error)
            }
        }
    }
}
