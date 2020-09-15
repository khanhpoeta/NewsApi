//
//  TopHeadlinesService.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import RxSwift

struct TopHeadlinesService {
    
    func articles(request:TopHeadlineRequest) -> Observable<[Article]?> {
        let endPoint = NewsEndPoint.topHeadline(request: request)
        return NewsService().performApi(endPoint: endPoint)
    }
}
