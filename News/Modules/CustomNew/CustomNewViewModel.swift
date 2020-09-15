//
//  CustomNewViewModel.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import RxSwift
import Action

class CustomNewViewInput:Input{
    lazy var reachedBottomTrigger = {
        return PublishSubject<Void>.init()
    }()
    
    lazy var keyWordDidChanged = {
        return PublishSubject<EveryThinkRequest.KeyWordSearch>.init()
    }()
}

class CustomNewModelOutput: Output {
    fileprivate(set) var articles:Observable<[Article]>?
    fileprivate(set) var isLoading: Observable<Bool>?
}

class CustomNewViewModel: ViewModel<CustomNewViewInput, CustomNewModelOutput> {
    
    lazy var articles = {
        return BehaviorSubject<[Article]>.init(value: [])
    }()
    
    private var searchApiState = EveryThinkRequest.init(key: .bitcoint,page: 1)
    
    override func binding() {
        
        self.output.articles = self.articles.asObserver()
        self.input.keyWordDidChanged.subscribe { [weak self](event) in
            self?.searchApiState.page = 1
            self?.searchApiState.key = event.element ?? EveryThinkRequest.KeyWordSearch.bitcoint
            self?.articles.onNext([])
        }.disposed(by: disposeBag)
        
        let searchAction = Action{ request in
            return EveryThinkService().articles(request: request)
        }
        
        self.error = searchAction.errors.map { err in NSError(domain: err.localizedDescription, code: 0, userInfo: nil) }
        
        let isLoading = searchAction.executing.startWith(false)
        
        self.output.isLoading = isLoading
        
        self.input.reachedBottomTrigger.asObserver()
            .withLatestFrom(Observable.just(self.searchApiState))
            .map {
                EveryThinkRequest.init(key: $0.key,page: $0.page)
        }
        .withLatestFrom(isLoading) { ($0, $1) }
        .filter{ !$0.1 }
        .map { $0.0 }
        .bind(to: searchAction.inputs)
        .disposed(by: disposeBag)
        
        searchAction.elements.map{ $0 }
            .withLatestFrom(self.articles) {($1, $0)}
            .map{ $0.0 + ($0.1 ?? []) }.subscribe({ [weak self](event) in
                self?.articles.onNext(event.element ?? [])
                self?.searchApiState.page += 1
            })
            .disposed(by: disposeBag)
        
        self.input.reachedBottomTrigger.asObserver()
            .withLatestFrom(Observable.just(searchApiState))
            .bind(to: searchAction.inputs)
            .disposed(by: disposeBag)
        
        
    }
}
