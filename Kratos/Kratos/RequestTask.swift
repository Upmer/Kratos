//
//  RequestTask.swift
//  unicorn-ios
//
//  Created by tsuf on 2019/4/17.
//  Copyright © 2019 lookwide. All rights reserved.
//

import UIKit
import Alamofire

public enum RequestError: Error {
  case parameters
  case json
  case response(Int, AnyObject?)
  case network(Error?)
}

public struct EmptyResult: Codable {
  
}

public enum HttpRequestType: String {
  case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

public class RequestTask<T> where T: Codable {
  typealias SuccessHandlerType = ((AnyObject?) -> Void)
  typealias ResultHandlerType = ((T?) -> Void)
  typealias FailureHandlerType = ((RequestError?) -> Void)
  typealias FinishHandlerType = (() -> Void)
  typealias FilterHandlerType = ((AnyObject) -> AnyObject)
  
  var url: String
  var type: HttpRequestType
  var isPrintError: Bool = true
  
  var params: [String: Any]?
  var headers: HTTPHeaders?
  
  var successHandler: SuccessHandlerType?
  var resultHandler: ResultHandlerType?
  var failureHandler: FailureHandlerType?
  var finishHandler: FinishHandlerType?
  var lastHandler: FinishHandlerType?
  var filterHandler: FilterHandlerType?
  
  var httpRequest: Request?
  
  deinit {
//    debugPrint("task:(\(url)) deinit")
  }
  
  init(url: String, type: HttpRequestType = .GET) {
    self.url = url
    self.type = type
  }
  
  convenience init() {
    self.init(url: "")
  }
  
  func params(params: [String: Any]) -> Self {
    self.params = params
    return self
  }
  
  func headers(headers: HTTPHeaders) -> Self {
    self.headers = headers
    return self
  }
  
  func filter(_ handler: @escaping FilterHandlerType) -> Self {
    self.filterHandler = handler
    return self
  }
  
  func finish(_ handler: @escaping FinishHandlerType) -> Self {
    self.finishHandler = handler
    return self
  }
  
  func last(_ handler: @escaping FinishHandlerType) -> Self {
    self.lastHandler = handler
    return self
  }
  
  func success(_ handler: @escaping SuccessHandlerType) -> Self {
    self.successHandler = handler
    return self
  }
  
  func result(_ handler: @escaping ResultHandlerType) -> Self {
    self.resultHandler = handler
    return self
  }
  
  func failure(_ handler: @escaping FailureHandlerType) -> Self {
    self.failureHandler = handler
    return self
  }
  
  private var json: AnyObject?
  private var data: Data?
  func receive(json: AnyObject?, data: Data?) {
    self.json = json
    self.data = data
  }
  
  func mapJsonToModel() -> T? {
    guard let json = self.json, JSONSerialization.isValidJSONObject(json) else {
      return nil
    }
    if let filter = self.filterHandler {
      let filterJson = filter(json)
      do {
        self.data = try JSONSerialization.data(withJSONObject: filterJson, options: [])
      } catch {
        return nil
      }
    }
    guard let data = data else {
      return nil
    }
    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      return nil
    }
  }
}
