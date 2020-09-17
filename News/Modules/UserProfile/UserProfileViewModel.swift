//
//  UserProfileViewModel.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import RxSwift
import Action

class UserProfileViewInput:Input{
    
    lazy var firstNameChanged = {
        return PublishSubject<String?>.init()
    }()
    
    lazy var lasNameChanged = {
        return PublishSubject<String?>.init()
    }()
    
}

class UserProfileViewModelOutput: Output {
    fileprivate(set) var currentUser:Observable<User?>?
}

class UserProfileViewModel: ViewModel<UserProfileViewInput, UserProfileViewModelOutput> {
    
    private let currentUserID:String = Bundle.main.bundleIdentifier!
    
    private lazy var currentUser = {
        return BehaviorSubject<User?>.init(value: nil)
    }()
    
    override func binding() {
        self.output.currentUser = self.currentUser.asObserver()
        
        var user:User! = RealmProvider().object(User.self, key: currentUserID)
        
        if user == nil
        {
            user = User.init(id: currentUserID)
            RealmProvider().save(user!).subscribe().disposed(by: disposeBag)
        }
        
        self.currentUser.onNext(user)
        
        self.input.lasNameChanged
            .map{ valueChanged in user.rx.lastName.onNext(valueChanged)}
            .subscribe()
            .disposed(by: disposeBag)
        
        self.input.firstNameChanged
            .map{ valueChanged in user.rx.firstName.onNext(valueChanged)}
            .subscribe()
            .disposed(by: disposeBag)
        
    }
    
}
