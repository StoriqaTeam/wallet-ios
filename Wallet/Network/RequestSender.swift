//
//  RequestSender.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Alamofire

protocol RequestSenderDelegate: class {
    func requestSucceed(_ request: Request, data: [String: AnyObject])
    func requestFailed(_ request: Request, apiErrors: [ResponseAPIError.Message])
    func requestFailed(_ request: Request, message: String)
}

protocol AbstractRequestSender {
    var delegate: RequestSenderDelegate? { set get }
    func sentGrqphQLRequest(_ request: Request)
    func send(_ request: Request)
}

class RequestSender: AbstractRequestSender {
    weak var delegate: RequestSenderDelegate?
    
    func sentGrqphQLRequest(_ request: Request) {
        send(request, url: NetworkConfig.graphqlUrl)
    }
    
    func send(_ request: Request) {
        send(request, url: NetworkConfig.url)
    }
    
    private func send(_ request: Request, url: String) {
        
        //        let url = URL(string: NetworkConfig.url)!
        //        let mutableUrlRequest = NSMutableURLRequest(url: url)
        //        mutableUrlRequest.httpMethod = "GET"
        //
        //        let cookie = UserDefaults.standard.value(forKey: "COOKIE") as! String
        //        mutableUrlRequest.setValue(cookie, forHTTPHeaderField: "Cookie")
        
        print("\nrequest headers: \n\(request.headers) \nrequest params: \n\(request.parameters ?? [:])\n")
        
        let queue = DispatchQueue(label: "RequestSender", qos: .background, attributes: .concurrent)
        
        Alamofire.request(url,
                          method: .post,
                          parameters: request.parameters,
                          encoding: JSONEncoding.default,
                          headers: request.headers).responseJSON(queue: queue) { (response) in
                            print(response)
                            
                            let unknownError = "Unknown error"
                            if let error = response.result.error {
                                DispatchQueue.main.async {[weak self] in
                                    self?.delegate?.requestFailed(request, message: error.localizedDescription)
                                }
                                return
                            }
                            
                            guard let responseData = response.data,
                                let dict = (try? JSONSerialization.jsonObject(with: responseData, options: [])) as? [String: Any] else {
                                    DispatchQueue.main.async {[weak self] in
                                        self?.delegate?.requestFailed(request, message: unknownError)
                                    }
                                    return
                            }
                            
                            if let errorsData = dict["errors"] as? [[String: AnyObject]] {
                                let errors = errorsData.compactMap({ (dict) -> ResponseError? in
                                    return .parseError(dict)
                                })
                                
                                guard !errors.isEmpty else {
                                    DispatchQueue.main.async {[weak self] in
                                        self?.delegate?.requestFailed(request, message: unknownError)
                                    }
                                    return
                                }
                                
                                let apiErrors = ResponseError.getApiErrorMessages(errors: errors)
                                if !apiErrors.isEmpty {
                                    DispatchQueue.main.async {[weak self] in
                                        self?.delegate?.requestFailed(request, apiErrors: apiErrors)
                                    }
                                }
                                
                                let defaultError = ResponseError.getTextError(errors: errors)
                                if !defaultError.isEmpty {
                                    DispatchQueue.main.async {[weak self] in
                                        self?.delegate?.requestFailed(request, message: defaultError)
                                    }
                                }
                            } else if let data = dict["data"] as? [String: AnyObject] {
                                DispatchQueue.main.async {[weak self] in
                                    self?.delegate?.requestSucceed(request, data: data)
                                }
                                
                            } else {
                                DispatchQueue.main.async {[weak self] in
                                    self?.delegate?.requestFailed(request, message: unknownError)
                                }
                            }
        }
    }
}
