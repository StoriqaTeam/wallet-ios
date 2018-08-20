//
//  RequestSender.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Alamofire

enum ResponseType {
    case success(data: [String: AnyObject])
    case apiErrors(errors: [ResponseError])
    case textError(message: String)
    
    static var unknownError = ResponseType.textError(message: "Unknown error")
}

class RequestSender {
    func send(_ request: Request, completion: ((ResponseType) -> Void)? ) {
        
        //        let url = URL(string: NetworkConfig.url)!
        //        let mutableUrlRequest = NSMutableURLRequest(url: url)
        //        mutableUrlRequest.httpMethod = "GET"
        //
        //        let cookie = UserDefaults.standard.value(forKey: "COOKIE") as! String
        //        mutableUrlRequest.setValue(cookie, forHTTPHeaderField: "Cookie")
        
        print("\nrequest headers: \n\(request.headers) \nrequest params: \n\(request.parameters ?? [:])\n")
        
        let queue = DispatchQueue(label: "RequestSender", qos: .background, attributes: .concurrent)
        
        Alamofire.request(NetworkConfig.url,
                          method: .post,
                          parameters: request.parameters,
                          encoding: JSONEncoding.default,
                          headers: request.headers).responseJSON(queue: queue) { (response) in
                            print(response)
                            
                            if let error = response.result.error {
                                DispatchQueue.main.async {
                                    completion?(.textError(message: error.localizedDescription))
                                }
                                return
                            }
                            
                            guard let responseData = response.data,
                                let json = try? JSONSerialization.jsonObject(with: responseData, options: []),
                                let dict = json as? [String: Any] else {
                                    DispatchQueue.main.async {
                                        completion?(.unknownError)
                                    }
                                    return
                            }
                            
                            if let errorsData = dict["errors"] as? [[String: AnyObject]] {
                                let errors = errorsData.compactMap({ (dict) -> ResponseError? in
                                    return .parseError(dict)
                                })
                                
                                guard !errors.isEmpty else {
                                    DispatchQueue.main.async {
                                        completion?(.unknownError)
                                    }
                                    return
                                }
                                
                                DispatchQueue.main.async {
                                    completion?(.apiErrors(errors: errors))
                                }
                                
                            } else if let data = dict["data"] as? [String: AnyObject] {
                                DispatchQueue.main.async {
                                    completion?(.success(data: data))
                                }
                                
                            } else {
                                DispatchQueue.main.async {
                                    completion?(.unknownError)
                                }
                            }
        }
    }
}
