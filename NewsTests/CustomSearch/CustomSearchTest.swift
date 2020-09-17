//
//  CustomSearchTest.swift
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

class CustomSearchTest: QuickSpec {
    
    func testKeyQuery(request:URLRequest, value:String)
    {
        let urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
        let results = urlComponents?.queryItems?.filter({ (queryItem) -> Bool in
            return queryItem.name == "q" && queryItem.value == value
        })
        XCTAssertEqual(results?.count, 1)
    }
    
    override func spec() {
        var viewModel:CustomNewViewModel!
        var disposeBag:DisposeBag!
        
        var testScheduler: TestScheduler!
        
        // Input
        var nextPage: TestableObservable<Void>!
        var queryKeySearch: TestableObservable<EveryThinkRequest.KeyWordSearch>!
        // Output
        
        var articleResponse: TestableObserver<[Article]>!
        
        func bindInputsToModelView() {
            nextPage?.bind(to: viewModel.input.reachedBottomTrigger).disposed(by: disposeBag)
            queryKeySearch?.bind(to: viewModel.input.keyWordDidChanged).disposed(by: disposeBag)
        }
        
        func bindOutputsToModelView() {
            if let output = viewModel.output.articles
            {
                articleResponse = testScheduler.record(output)
            }
        }
        
        func startSchedule() {
            bindInputsToModelView()
            bindOutputsToModelView()
            testScheduler.start()
        }
        
        beforeEach {
            testScheduler = TestScheduler(initialClock: 0)
        }
        
        describe("Test CustomSearchViewModel with Response") {
            context("Success with Response", closure: {
                beforeEach {
                    viewModel = CustomNewViewModel()
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
                it("Return failed response", closure: {
                    let testBundle = Bundle(for: type(of: self))
                    let bundleURL = testBundle.path(forResource: "news_api_failed", ofType: "json")
                    nextPage = testScheduler.createHotObservable([Recorded.next(500, ())])
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
        
        describe("Test CustomSearchViewModel with key query") {
            beforeEach {
                viewModel = CustomNewViewModel()
                disposeBag = DisposeBag()
            }
            
            afterEach {
                viewModel.unBinding()
                viewModel = nil
                disposeBag = nil
            }
            
            context("Success with default query is bitcoint", closure: {
                let isCurrentTest = true
                it("Return correct response", closure: {
                    let testBundle = Bundle(for: type(of: self))
                    let bundleURL = testBundle.path(forResource: "news_api_success", ofType: "json")
                    nextPage = testScheduler.createHotObservable([Recorded.next(100, ())])
                    stub(condition: { [weak self](request) -> Bool in
                        if isCurrentTest{
                            self?.testKeyQuery(request: request, value: EveryThinkRequest.KeyWordSearch.bitcoint.rawValue)
                        }
                        return true
                    }) { (request) -> HTTPStubsResponse in
                        return HTTPStubsResponse.init(fileAtPath: bundleURL!, statusCode: 200, headers: nil)
                    }
                    startSchedule()
                })
            })
            
            context("Success with query is apple", closure: {
                let isCurrentTest = true
                it("Return correct response", closure: {
                    let testBundle = Bundle(for: type(of: self))
                    let bundleURL = testBundle.path(forResource: "news_api_success", ofType: "json")
                    queryKeySearch = testScheduler.createHotObservable([Recorded.next(200, EveryThinkRequest.KeyWordSearch.apple)])
                    stub(condition: {[weak self] (request) -> Bool in
                        if isCurrentTest{
                            self?.testKeyQuery(request: request, value: EveryThinkRequest.KeyWordSearch.apple.rawValue)
                        }
                        return true
                    }) { (request) -> HTTPStubsResponse in
                        return HTTPStubsResponse.init(fileAtPath: bundleURL!, statusCode: 200, headers: nil)
                    }
                    startSchedule()
                })
            })
            
            context("Success with query is earthquake", closure: {
                let isCurrentTest = true
                it("Return correct response", closure: {
                    let testBundle = Bundle(for: type(of: self))
                    let bundleURL = testBundle.path(forResource: "news_api_success", ofType: "json")
                    queryKeySearch = testScheduler.createHotObservable([Recorded.next(300, EveryThinkRequest.KeyWordSearch.earthquake)])
                    stub(condition: {[weak self] (request) -> Bool in
                        if isCurrentTest{
                            self?.testKeyQuery(request: request, value: EveryThinkRequest.KeyWordSearch.earthquake.rawValue)
                        }
                        return true
                    }) { (request) -> HTTPStubsResponse in
                        return HTTPStubsResponse.init(fileAtPath: bundleURL!, statusCode: 200, headers: nil)
                    }
                    startSchedule()
                })
            })
            
            context("Success with query is animal", closure: {
                let isCurrentTest = true
                it("Return correct response", closure: {
                    let testBundle = Bundle(for: type(of: self))
                    let bundleURL = testBundle.path(forResource: "news_api_success", ofType: "json")
                    queryKeySearch = testScheduler.createHotObservable([Recorded.next(400, EveryThinkRequest.KeyWordSearch.animal)])
                    stub(condition: {[weak self] (request) -> Bool in
                        if isCurrentTest{
                            self?.testKeyQuery(request: request, value: EveryThinkRequest.KeyWordSearch.animal.rawValue)
                        }
                        return true
                    }) { (request) -> HTTPStubsResponse in
                        return HTTPStubsResponse.init(fileAtPath: bundleURL!, statusCode: 200, headers: nil)
                    }
                    startSchedule()
                })
            })
        }
    }
    
}

