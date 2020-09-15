//
//  Article.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import ObjectMapper

struct Article: ImmutableMappable {
    
    let author:String?
    let title:String?
    let source:String?
    let url:String?
    let urlToImage:String?
    let publishedAt:Date?
    let content:String?
    
   init(map: Map) throws {
       author   = try map.value("author")
       title = try? map.value("title")
       source = try? map.value("source.name")
       url = try? map.value("url")
       urlToImage = try? map.value("urlToImage")
       publishedAt = try? map.value("publishedAt")
       content = try? map.value("content")
   }
    
}
