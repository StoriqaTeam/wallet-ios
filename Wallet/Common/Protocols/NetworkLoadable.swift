//
//  NetworkLoadable.swift
//  Wallet
//
//  Created by Storiqa on 18.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkLoadable {
    typealias ResultJSONBlock = (Result<(responseStatusCode: Int, value: Any)>) -> Void
    func loadObjectJSON(request: URLRequestConvertible, queue: DispatchQueue, completion: @escaping ResultJSONBlock)
}

extension NetworkLoadable {
    
    func loadObjectJSON(request: URLRequestConvertible, queue: DispatchQueue, completion: @escaping ResultJSONBlock) {
        let operation = AnyOperation(request: request,
                                     responseSerializer: DataRequest.jsonResponseSerializer(options: .allowFragments),
                                     completion: completion)
        operation.execute(queue: queue)
    }
    
}

private protocol NetworkOperationProtocol {
    associatedtype ResponseSerializer: DataResponseSerializerProtocol
    typealias ResponseObject = ResponseSerializer.SerializedObject
    
    var request: URLRequestConvertible { get }
    var responseSerializer: ResponseSerializer { get }
    var completion: ((Result<(responseStatusCode: Int, value: ResponseObject)>) -> Void)? { get }
}

private struct AnyOperation<ResponseSerializer: DataResponseSerializerProtocol>: NetworkOperationProtocol {
    
    var request: URLRequestConvertible
    var responseSerializer: ResponseSerializer
    var completion: ((Result<(responseStatusCode: Int, value: ResponseSerializer.SerializedObject)>) -> Void)?
    
    func execute(queue: DispatchQueue) {
        let task = Alamofire.request(request).response(queue: queue, responseSerializer: responseSerializer) { response in
            switch response.result {
            case .success(let value):
                let code = response.response?.statusCode ?? 0
                self.completion?(Result.success((code, value)))
                
                let responseStr = "Response \(self.request): \ncode: \(code) \njson: \(JSON(value))"
                switch code {
                case 200:
                    log.debug(responseStr)
                default:
                    log.warn(responseStr)
                }
            case .failure(let error):
                self.completion?(Result.failure(error))
                
                log.error("Response \(self.request): \nerror: \(error.localizedDescription)")
            }
            
        }
        log.debug("Request: \(task.debugDescription)")
    }
}
