//
//  RealmBaseEntity.swift
//  News
//
//  Created by Kent Nguyen on 9/16/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import RealmSwift

class RealmBaseEntity: Object {
    
    init(id:String)
    {
        super.init()
        self.id = id
    }
    
    required init() {
        super.init()
    }
    
    @objc dynamic var id:String = UUID().uuidString
    @objc dynamic var name:String?
    @objc dynamic var des:String?
    @objc dynamic var createdDate:Date = Date()
    @objc dynamic var updateDate:Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func save(){
        RealmProvider().save(self).subscribe().dispose()
    }
    
    func insert(){
        RealmProvider().insert(self).subscribe().dispose()
    }
}
