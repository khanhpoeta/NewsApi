//
//  NewsService.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import ObjectMapper

class NewsService<T:BaseMappable>: ApiService {
    
    init() {
        super.init([ApiKeyPlugin(apiKey: Configuration.shared.apiKey),NetworkLoggerPlugin.init()])
    }
    
    func performApi(endPoint:NewsEndPoint)->Observable<[T]?>{
        return self.request(endPoint: endPoint).compactMap { (json) -> [T]? in
            guard let jsonData = json else
            {
                return nil
            }
            let response = ParserFactory<ArticalResponse<T>>().entity(jsonData)
            return response?.data
        }
    }
}


