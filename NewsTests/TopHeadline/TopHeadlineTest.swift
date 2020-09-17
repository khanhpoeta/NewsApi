//
//  TopHeadlineTest.swift
//  NewsTests
//
//  Created by Kent Nguyen on 9/16/20.
//  Copyright © 2020 NeAlo. All rights reserved.
//

import XCTest
import Quick
import RxSwift
import RxTest
import RxBlocking
import Nimble
import OHHTTPStubs

@testable import News

class TopHeadlineTest: QuickSpec {
    
    override func spec() {
        var viewModel:TopHeadLineViewModel!
        var disposeBag:DisposeBag!
        
        var testScheduler: TestScheduler!
        var nextPage: TestableObservable<Void>!
        
        func bindInputsToModelView() {
            if nextPage != nil {
                nextPage.bind(to: viewModel.input.reachedBottomTrigger).disposed(by: disposeBag)
            }
        }
        
        func startSchedule() {
            testScheduler.start()
        }
        
        beforeEach {
            testScheduler = TestScheduler(initialClock: 0)
        }
        
        describe("Test TopHeadlineViewModel") {
            context("Success", closure: {
                beforeEach {
                    viewModel = TopHeadLineViewModel()
                    disposeBag = DisposeBag()
                }
                it("Return correct response", closure: {
                    let testBundle = Bundle(for: type(of: self))
                    let bundleURL = testBundle.path(forResource: "news_api_success", ofType: "json")
                    nextPage = testScheduler.createHotObservable([Recorded.next(100, ())])
                    bindInputsToModelView()
                    stub(condition: { (request) -> Bool in
                        return true
                    }) { (request) -> HTTPStubsResponse in
                        return HTTPStubsResponse.init(fileAtPath: bundleURL!, statusCode: 200, headers: nil)
                    }
                    startSchedule()
                    viewModel.output.articles?.skip(1).subscribe { (event) in
                        do {
                            let data = try Data(contentsOf: URL(fileURLWithPath: bundleURL!), options: .mappedIfSafe)
                            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let articles = jsonResult["articles"] as? [[String:Any]] {
                                let entities = ParserFactory<Article>().entities(articles)
                                XCTAssertEqual(event.element, entities)
                            }
                        } catch {
                            // contents could not be loaded
                        }
                    }.disposed(by: disposeBag)
                })
            })
            
            context("Failed", closure: {
                beforeEach {
                    viewModel = TopHeadLineViewModel()
                    disposeBag = DisposeBag()
                }
                it("Return failed response", closure: {
                    let testBundle = Bundle(for: type(of: self))
                    let bundleURL = testBundle.path(forResource: "news_api_failed", ofType: "json")
                    nextPage = testScheduler.createHotObservable([Recorded.next(100, ())])
                    bindInputsToModelView()
                    stub(condition: { (request) -> Bool in
                        return true
                    }) { (request) -> HTTPStubsResponse in
                        return HTTPStubsResponse.init(fileAtPath: bundleURL!, statusCode: 400, headers: nil)
                    }
                    startSchedule()
                    viewModel.error?.subscribe({ (event) in
                        expect(event.element).toNot(beNil())
                    }).disposed(by: disposeBag)
                })
            })
        }
    }
    
}
