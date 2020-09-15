//
//  ArticleRequest.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import ObjectMapper

class TopHeadlineRequest:Mappable {
    
    required init?(map: Map) {
        
    }
    
    var country:String?
    let category:String = "general"
    var key:String?
    var page:Int = 1
    var pageSize = 10
    
    init(page:Int){
        self.country = nil
        self.key = nil
        self.page = page
    }
    
    init(country:String?, category:String, key:String?){
        self.country = country
        self.key = key
    }
    
    func mapping(map: Map) {
        category >>> map["category"]
        page >>> map["page"]
        pageSize >>> map["pageSize"]
        key >>> map["q"]
        country >>> map["country"]
    }
    
}

