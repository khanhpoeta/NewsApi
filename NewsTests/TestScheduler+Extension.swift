//
//  TestScheduler+Extension.swift
//  NewsTests
//
//  Created by Kent Nguyen on 9/16/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import RxSwift
import RxTest
import RxCocoa

extension TestScheduler {
    /// Creates a `TestableObserver` instance which immediately subscribes
    /// to the `source` and disposes the subscription at virtual time 100000.
    func record<O: ObservableConvertibleType>(_ source: O) -> TestableObserver<O.Element> {
        let observer = self.createObserver(O.Element.self)
        let disposable = source.asObservable().bind(to: observer)
        self.scheduleAt(100000) {
            disposable.dispose()
        }
        return observer
    }
}
