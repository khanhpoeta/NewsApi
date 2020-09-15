//
//  ApiKeyPlugin.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import Moya

struct ApiKeyPlugin: Moya.PluginType {
    
    public typealias ApiKey = String

    public let apiKey:ApiKey

    public init(apiKey:ApiKey){
        self.apiKey = apiKey
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems?.append(URLQueryItem.init(name: "apiKey", value: self.apiKey))
        do{
            if let url = try urlComponents?.asURL()
            {
                return try URLRequest.init(url: url, method: request.method ?? .get, headers: request.headers)
            }
        }
        catch{
        
        }
        return request
    }
}
