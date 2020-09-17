//
//  TopHeadLineViewModel.swift
//  News
//
//  Created by Kent Nguyen on 9/15/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import UIKit
import RxSwift
import Action

class TopHeadLineViewInput:Input{
    lazy var reachedBottomTrigger = {
        return PublishSubject<Void>.init()
    }()
}

class TopHeadLineModelOutput: Output {
    fileprivate(set) var articles:Observable<[Article]>?
    fileprivate(set) var isLoading: Observable<Bool>?
}

class TopHeadLineViewModel: ViewModel<TopHeadLineViewInput, TopHeadLineModelOutput> {
    
    
    private var searchApiState: TopHeadlineRequest = TopHeadlineRequest(page: 1)
    
    private lazy var articles = {
        return BehaviorSubject<[Article]>.init(value: [])
    }()
    
    private var isLoading:Observable<Bool>?
    
    override func binding() {
        self.output.articles = self.articles.asObserver()
        
        let searchAction = Action{ request in
            return TopHeadlinesService().articles(request: request)
        }
        
        self.error = searchAction.errors.map { err in NSError(domain: err.localizedDescription, code: 0, userInfo: nil) }
        
        isLoading = searchAction.executing.startWith(false)
        self.output.isLoading = isLoading
        
        self.input.reachedBottomTrigger.asObserver()
            .withLatestFrom(Observable.just(self.searchApiState))
            .map { TopHeadlineRequest(page: $0.page) }
            .withLatestFrom(isLoading!) { ($0, $1) }
            .filter{ !$0.1 }
            .map { $0.0 }
            .bind(to: searchAction.inputs)
            .disposed(by: disposeBag)
        
        searchAction.elements.map{ $0 }
            .withLatestFrom(self.articles) {($1, $0)}
            .map{ $0.0 + ($0.1 ?? []) }
            .subscribe({ [weak self](event) in
                self?.articles.onNext(event.element ?? [])
                self?.searchApiState.page += 1
            })
            .disposed(by: disposeBag)
    }
}
