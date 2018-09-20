//
//  RequestSender.swift
//  Wallet
//
//  Created by Storiqa on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Alamofire

protocol AbstractRequestSender {
    func sendGrqphQLRequest(_ request: Request, completion: @escaping (ResponseType)->Void)
    func send(_ request: Request, completion: @escaping (ResponseType)->Void)
}

class RequestSender: AbstractRequestSender {
    func sendGrqphQLRequest(_ request: Request, completion: @escaping (ResponseType)->Void) {
        send(request, url: NetworkConfig.graphqlUrl, completion: completion)
    }
    
    func send(_ request: Request, completion: @escaping (ResponseType)->Void) {
        send(request, url: NetworkConfig.url, completion: completion)
    }
    
    private func send(_ request: Request, url: String, completion: @escaping (ResponseType)->Void) {
        
        //        let url = URL(string: NetworkConfig.url)!
        //        let mutableUrlRequest = NSMutableURLRequest(url: url)
        //        mutableUrlRequest.httpMethod = "GET"
        //
        //        let cookie = UserDefaults.standard.value(forKey: "COOKIE") as! String
        //        mutableUrlRequest.setValue(cookie, forHTTPHeaderField: "Cookie")
        
        log.debug("\nrequest headers: \n\(request.headers) \nrequest params: \n\(request.parameters )\n")
        
        let queue = DispatchQueue(label: "RequestSender", qos: .background, attributes: .concurrent)
        
        Alamofire.request(url,
                          method: .post,
                          parameters: request.parameters,
                          encoding: JSONEncoding.default,
                          headers: request.headers).responseJSON(queue: queue) { (response) in
                            log.debug(response)
                            
                            if let error = response.result.error {
                                DispatchQueue.main.async {
                                    completion(ResponseType.textError(message: error.localizedDescription))
                                }
                                return
                            }
                            
                            guard let responseData = response.data,
                                let dict = (try? JSONSerialization.jsonObject(with: responseData, options: [])) as? [String: AnyObject] else {
                                    DispatchQueue.main.async {
                                        completion(.unknownError)
                                    }
                                    return
                            }
                            
                            if let errorsData = dict["errors"] as? [[String: AnyObject]] {
                                let errors = errorsData.compactMap({ (dict) -> ResponseError? in
                                    return .parseError(dict)
                                })
                                
                                guard !errors.isEmpty else {
                                    DispatchQueue.main.async {
                                        completion(.unknownError)
                                    }
                                    return
                                }
                                
                                let apiErrors = ResponseError.getApiErrorMessages(errors: errors)
                                if !apiErrors.isEmpty {
                                    DispatchQueue.main.async {
                                        completion(ResponseType.apiErrors(errors: apiErrors))
                                    }
                                }
                                
                                let defaultError = ResponseError.getTextError(errors: errors)
                                if !defaultError.isEmpty {
                                    DispatchQueue.main.async {
                                        completion(.textError(message: defaultError))
                                    }
                                }
                            } else if let data = dict["data"] as? [String: AnyObject] {
                                DispatchQueue.main.async {
                                    completion(.success(data: data))
                                }
                            } else {
                                DispatchQueue.main.async {
                                    completion(.unknownError)
                                }
                            }
        }
    }
}
