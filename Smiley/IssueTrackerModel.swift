//
//  IssueTrackerModel.swift
//  Smiley
//
//  Created by Lin He on 9/22/16.
//  Copyright © 2016 heroxtech. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Argo

struct IssueTrackerModel {
  let provider: RxMoyaProvider<GitHub>
  let repositoryName: Observable<String>
  
  func trackIssues() -> Observable<[Issue]> {
    return repositoryName
      .observeOn(MainScheduler.instance)
      .flatMapLatest { name -> Observable<Repository> in
        print("Name: \(name)")
        return self.findRepository(name: name)
      }
      .flatMapLatest { repository -> Observable<[Issue]> in
        print("Repository: \(repository.fullName)")
        return self.findIssues(repository: repository)
      }
  }

  internal func findIssues(repository: Repository) -> Observable<[Issue]> {
    return self.provider
      .request(GitHub.Issues(repositoryFullName: repository.fullName))
      .mapArray(type: Issue.self)
  }

  internal func findRepository(name: String) -> Observable<Repository> {
    return self.provider
      .request(GitHub.Repo(fullName: name))
//      .debug()
      .mapObject(type: Repository.self)
  }
}