//
//  MovieLoader.swift
//  Kratos
//
//  Created by ByteDance on 2020/6/8.
//  Copyright © 2020 Upmer. All rights reserved.
//

import UIKit

let FLASHUIGITHUBAPI = "https://api.github.com/repos/Upmer/FlashUI"

struct GithubRepo: Codable {
  var id: Int64
  var name: String
  var url: String
  var full_name: String
  var git_url: String
  var ssh_url: String
}

struct RepoOwner: Codable {
  var id: Int64
  var login: String
  var url: String
  var avatar_url: String
}

class GithubLoader {
  static func requestRepo() -> RequestTask<GithubRepo> {
    return RequestTask<GithubRepo>(url: FLASHUIGITHUBAPI)
  }
  
  static func requestRepoOwner() -> RequestTask<RepoOwner> {
    return RequestTask<RepoOwner>(url: FLASHUIGITHUBAPI).filter {
      return $0["owner"] as AnyObject
    }
  }
}
