//
//  RequestManager.swift
//  unicorn-ios
//
//  Created by tsuf on 2019/4/17.
//  Copyright © 2019 lookwide. All rights reserved.
//

import UIKit
import Alamofire

class RequestManager {
  
  private var session: Session
  
  static let _singleton = RequestManager()
  
  static var shared: RequestManager { return _singleton }
  
  private init() {
    self.session = Session()
  }
  
  let configuration: URLSessionConfiguration = {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 30
    config.timeoutIntervalForResource = 120
    return config
  }()
  
  func start<T>(_ task: RequestTask<T>) where T: Codable {
    let type = HTTPMethod(rawValue: task.type.rawValue)
    session.request(task.url, method: type, parameters: task.params, encoding: JSONEncoding.default, headers: task.headers).response { (response) in
      
      task.finishHandler?()
      defer { task.lastHandler?() }
      
      guard let statusCode = response.response?.statusCode else {
        task.failureHandler?(RequestError.network(response.error))
        return
      }
      
      let data: Data? = response.data
      var value: Any? = nil
      if let data = data {
        value = try? JSONSerialization.jsonObject(with: data, options: [])
      }
      task.receive(json: value as AnyObject?, data: data)
      
      guard (200...299).contains(statusCode) else { // error status code
        task.failureHandler?(RequestError.response(statusCode, value as AnyObject))
        if task.isPrintError {
          debugPrint("request \(task.url) error: \(String(describing: value))")
        }
        return
      }
      
      if let model = task.mapJsonToModel() {
        task.successHandler?(value as AnyObject)
        task.resultHandler?(model)
      } else {
        task.failureHandler?(RequestError.response(statusCode, value as AnyObject?))
      }
    }
  }
  
}
