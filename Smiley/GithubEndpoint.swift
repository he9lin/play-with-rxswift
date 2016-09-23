//
//  GithubEndpoint.swift
//  Smiley
//
//  Created by Lin He on 9/22/16.
//  Copyright © 2016 heroxtech. All rights reserved.
//

import Foundation
import Moya

private func JSONResponseDataFormatter(_ data: Data) -> Data {
  do {
    let dataAsJSON = try JSONSerialization.jsonObject(with: data)
    let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
    return prettyData
  } catch {
    return data //fallback to original data if it cant be serialized
  }
}

let GitHubProvider = MoyaProvider<GitHub>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

private extension String {
  var urlEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
}

enum GitHub {
  case UserProfile(username: String)
  case Repos(username: String)
  case Repo(fullName: String)
  case Issues(repositoryFullName: String)
}

extension GitHub: TargetType {
  public var baseURL: URL { return URL(string: "https://api.github.com")! }
  
  public var path: String {
    switch self {
    case .Repos(let name):
      return "/users/\(name.urlEscapedString)/repos"
    case .UserProfile(let name):
      return "/users/\(name.urlEscapedString)"
    case .Repo(let name):
      print("/repos/\(name)")
      return "/repos/\(name)"
    case .Issues(let repositoryName):
      return "/repos/\(repositoryName)/issues"
    }
  }
  
  var method: Moya.Method {
    return .GET
  }
  
  var parameters: [String: Any]? {
    return nil
  }
  
  public var task: Task {
    return .request
  }
  
  var sampleData: Data {
    switch self {
    case .Repos(_):
      return "{{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}}}".data(using: String.Encoding.utf8)!
    case .UserProfile(let name):
      return "{\"login\": \"\(name)\", \"id\": 100}".data(using: String.Encoding.utf8)!
    case .Repo(_):
      return "{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}".data(using: String.Encoding.utf8)!
    case .Issues(_):
      return "{\"id\": 132942471, \"number\": 405, \"title\": \"Updates example with fix to String extension by changing to Optional\", \"body\": \"Fix it pls.\"}".data(using: String.Encoding.utf8)!
    }
  }
  
  var multipartBody: [Moya.MultipartFormData]? {
    return nil
  }
}
