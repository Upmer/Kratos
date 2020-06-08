//
//  request_task_test.swift
//  unit-tests
//
//  Created by ByteDance on 2020/6/8.
//  Copyright © 2020 Upmer. All rights reserved.
//

import XCTest

struct Model: Codable {
  var key: String
}

class request_task_test: XCTestCase {
  
  var task: RequestTask<Model>!
  
  override func setUp() {
    task = RequestTask<Model>()
  }
  
  func testMapJsonToModel() {
    let json = ["key":"value"] as AnyObject
    let data = try! JSONSerialization.data(withJSONObject: json, options: [])
    task.receive(json: json, data: data)
    let model = task.mapJsonToModel()
    XCTAssertEqual(model!.key, "value")
  }
  
}
