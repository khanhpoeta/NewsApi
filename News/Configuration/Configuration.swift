//
//  Configuration.swift
//  LiveShopCast
//
//  Created by Kent Nguyen on 5/25/18.
//  Copyright © 2018 Poeta Digital. All rights reserved.
//

import UIKit

struct Configuration {

    private(set) var baseUrl:String = ""
    private(set) var apiKey:String = ""
    private(set) var realmPathName:String = "db.realm"
    static let shared = Configuration()
    
    init() {
        
        guard let _ = NSClassFromString("XCTest") else {
            if let url = Bundle.main.path(forResource: "Configuration", ofType: "plist") {
                let dictionary = NSDictionary(contentsOfFile: url)!
                baseUrl = (dictionary["baseUrl"] as? String) ?? ""
                apiKey = (dictionary["apiKey"] as? String) ?? ""
            }
            return
        }
        realmPathName = "test.realm"
    }
}
