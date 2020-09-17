//
//  ViewModel.swift
//  NeAlo
//
//  Created by Kent Nguyen on 9/12/19.
//  Copyright © 2019 Poeta Digital. All rights reserved.
//

import UIKit
import RxSwift

class Input {
    required init() {
        
    }
}

class Output {
    fileprivate(set) var error:Observable<Error>?
    required init() {
        
    }
}

protocol ViewModelInterface {
    init()
    var error:PublishSubject<Error> { get }
}

class ViewModel <InputModel:Input, OutputModel:Output> {
    
    private(set) var input = InputModel.init()
    private(set) var output = OutputModel.init()
    
    internal var disposeBag:DisposeBag!
    internal var cancel:Cancelable?
    internal var disposables:[Disposable] = []
    
    internal var error:Observable<Error>?
    
    required init() {
        disposeBag = DisposeBag.init()
        binding()
    }
    
    func binding(){
        
    }

    func unBinding(){
        disposeBag = nil
        cancel?.dispose()
        disposables.forEach { (dispose) in
            dispose.dispose()
        }
    }
    
    deinit {
        unBinding()
    }
}
