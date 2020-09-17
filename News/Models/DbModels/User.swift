//
//  User.swift
//  News
//
//  Created by Kent Nguyen on 9/16/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit

class User: RealmBaseEntity {
    
    @objc dynamic var dateOfBirth:Date = Date()
    @objc dynamic var firstName:String?
    @objc dynamic var lastName:String?
    
}
