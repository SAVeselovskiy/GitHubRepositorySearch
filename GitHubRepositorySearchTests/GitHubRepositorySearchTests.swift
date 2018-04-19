//
//  GitHubRepositorySearchTests.swift
//  GitHubRepositorySearchTests
//
//  Created by Сергей Веселовский on 18/04/2018.
//  Copyright © 2018 Сергей Веселовский. All rights reserved.
//

import XCTest

class GitHubRepositorySearchTests: XCTestCase {
    var provider: GitHubApiProvider?
    override func setUp() {
        super.setUp()
        self.provider = GitHubApiProvider()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        provider?.loadSearchResults(for: "Tag Cloud iOS", success: { (results) in
            assert(false)
        }, failure: { (error) in
            var loadingError = error
            if error == nil {
                loadingError = NSError(domain: "VSSearchList", code: 500, userInfo: nil)
            }
            print(loadingError?.localizedDescription as Any)
            assert(true)
        })
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
