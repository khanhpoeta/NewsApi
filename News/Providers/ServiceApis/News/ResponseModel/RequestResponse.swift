//
//  RequestResponse.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import ObjectMapper

struct ArticalResponse<T:BaseMappable>: Mappable {
    init?(map: Map) {
        
    }
    
    var data: [T]? = []
    var totalResults: Int = 0
    var code:Int = 0
    
    mutating func mapping(map: Map) {
        code            <- map["code"]
        totalResults    <- map["totalResults"]
        data            <- map["articles"]
    }
}
