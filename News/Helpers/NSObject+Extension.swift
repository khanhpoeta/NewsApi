//
//  NSObject+Extention.swift
//  LiveShopCast
//
//  Created by Kent Nguyen on 5/25/18.
//  Copyright © 2018 Poeta Digital. All rights reserved.
//

import UIKit

extension NSObject{
    
    static func getClassName()->String
    {
        let className = "\(self)"
        return className
    }
    
    func getClassName()->String{
        
        let className = "\(self.classForCoder)"
        
        let objStrings = className.components(separatedBy: ".")
        
        if objStrings.count > 1
        {
            return objStrings[0]
        }
        return className
    }
}
