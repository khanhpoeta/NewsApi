//
//  NewsEndPoint.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import Moya
import Alamofire

enum NewsEndPoint {
    case topHeadline(request:TopHeadlineRequest)
    case everyThing(request:EveryThinkRequest)
}

extension NewsEndPoint: TargetType {
    var baseURL: URL{
        let url:URL = URL(string: Configuration.shared.baseUrl)!
        return url
    }
    
    var path: String{
        switch self {
        case .topHeadline:
            return "top-headlines"
        case .everyThing:
            return "everything"
        }
    }
    
    var method: Moya.Method{
        return .get
    }
    
    var sampleData: Data{
        return Data()
    }
    
    var task: Task{
        switch self {
        case .topHeadline(let request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        case .everyThing(let request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]?{
        return nil
    }
    
    var validationType: ValidationType{
        return .successCodes
    }
}
