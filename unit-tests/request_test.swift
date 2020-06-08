//
//  request_test.swift
//  unit-tests
//
//  Created by ByteDance on 2020/6/8.
//  Copyright © 2020 Upmer. All rights reserved.
//

import XCTest

class request_test: XCTestCase {

  func testRequestRepo() {
    let exp = expectation(description: "repo")
    let task = GithubLoader.requestRepo()
      .result { (repo) in
        XCTAssertEqual(repo?.id, 194438931)
        XCTAssertEqual(repo?.name, "FlashUI")
        exp.fulfill()
    }.failure { (_) in
      XCTFail()
      exp.fulfill()
    }
    RequestManager.shared.start(task)
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func testRequestRepoOwner() {
    let exp = expectation(description: "repo owner")
    let task = GithubLoader.requestRepoOwner()
      .result { (owner) in
        XCTAssertEqual(owner?.id, 23350319)
        XCTAssertEqual(owner?.login, "Upmer")
        exp.fulfill()
    }.failure { (_) in
      XCTFail()
      exp.fulfill()
    }
    RequestManager.shared.start(task)
    waitForExpectations(timeout: 10, handler: nil)
  }
}
