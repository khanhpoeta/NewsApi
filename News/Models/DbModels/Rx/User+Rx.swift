//
//  User+Rx.swift
//  News
//
//  Created by Kent Nguyen on 9/17/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//
import RxSwift
import RxCocoa
import RealmSwift

extension Reactive where Base: User {
    
    /// Bindable sink for `text` property.
    
    var firstName: Binder<String?> {
        return Binder(self.base) { user, valueChanged in
            let realmProvider = RealmProvider()
            realmProvider.save {
                user.firstName = valueChanged
            }.subscribe().dispose()
        }
    }
    
    var lastName: Binder<String?> {
        return Binder(self.base) { user, valueChanged in
            let realmProvider = RealmProvider()
            realmProvider.save {
                user.lastName = valueChanged
            }.subscribe().dispose()
        }
    }
    
   
}
