//
//  BaseService.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import ObjectMapper
import Moya
import RxSwift

class ApiService {
    
    internal var plugins:[PluginType] = []
    
    init(_ plugins : [PluginType] = []) {
        self.plugins = plugins;
    }
    
    func request<Target:TargetType>(endPoint:Target)-> Observable<[String : Any]?>{
        return Observable.create({ (observer) -> Disposable in
            let cancellable = MoyaProvider<Target>(plugins:self.plugins).request(endPoint) { (result) in
                let data = self.handleResult(result: result)
                if let error = data as? Error
                {
                    observer.onError(error)
                    observer.onCompleted()
                    return
                }
                else if let jsonData = data as? [String : Any]
                {
                    observer.onNext(jsonData)
                }
                observer.onCompleted()
            }
            return Disposables.create {
                cancellable.cancel()
            }
        })
    }
    
    fileprivate func handleResult(result:Result<Response, MoyaError>)->Any?{
        var data:Any?
        switch result {
        case .success(let response):
            do {
                data = try response.filterSeverErrorCode()
                return data
            }
            catch (let error) {
                return error
            }
        case .failure(let error):
            return error
        }
    }
}
