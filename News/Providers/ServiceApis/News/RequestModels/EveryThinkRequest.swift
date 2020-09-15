//
//  EveryThinkRequest.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import ObjectMapper

class EveryThinkRequest:Mappable {
    
    required init?(map: Map) {
        
    }
    
    enum KeyWordSearch : String {
        case bitcoint = "bitcoint"
        case apple = "apple"
        case earthquake = "earthquake"
        case animal = "animal"
    }
    
    var qInTitle:String?
    var domains:String?
    var language:String?
    var key:KeyWordSearch = .bitcoint
    var sortBy:String?
    var from:Date?
    var to:Date?
    var page:Int = 1
    var pageSize = 10
    
    init(key:KeyWordSearch, page:Int){
        self.key = key
        self.qInTitle   = nil
        self.domains   = nil
        self.from   = nil
        self.to   = nil
        self.sortBy   = nil
        self.language   = nil
        self.page = page
    }
    
    func mapping(map: Map) {
        key >>> (map["q"], EnumTransform())
        pageSize >>> map["pageSize"]
        page >>> map["page"]
    }
    
}
