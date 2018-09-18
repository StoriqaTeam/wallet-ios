//
//  NetworkLoadable.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 18.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkLoadable {
    typealias ResultJSONBlock = (Result<Any>) -> Void
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
    var completion: ((Result<ResponseObject>) -> Void)? { get }
}

private struct AnyOperation<ResponseSerializer: DataResponseSerializerProtocol>: NetworkOperationProtocol {
    
    var request: URLRequestConvertible
    var responseSerializer: ResponseSerializer
    var completion: ((Result<ResponseSerializer.SerializedObject>) -> Void)?
    
    func execute(queue: DispatchQueue) {
        let task = Alamofire.request(request).response(queue: queue, responseSerializer: responseSerializer) { response in
            switch response.result {
            case .success(let value):
                self.completion?(Result.success(value))
            case .failure(let error):
                self.completion?(Result.failure(error))
            }
        }
        print(task.debugDescription)
    }
}
