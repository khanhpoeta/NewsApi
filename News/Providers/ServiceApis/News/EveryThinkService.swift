//
//  EveryThinkService.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import RxSwift

class EveryThinkService: NSObject {
    
    func articles(request:EveryThinkRequest) -> Observable<[Article]?> {
        let endPoint = NewsEndPoint.everyThing(request: request)
        return NewsService().performApi(endPoint: endPoint)
    }
}
