//
//  Issue.swift
//  Smiley
//
//  Created by Lin He on 9/22/16.
//  Copyright © 2016 heroxtech. All rights reserved.
//

import Argo
import Curry
import Runes

struct Issue {
  let id: Int
  let number: Int
  let title: String
  let body: String
}

extension Issue: Decodable {
  /**
   Decode an object from JSON.
   
   This is the main entry point for Argo. This function declares how the
   conforming type should be decoded from JSON. Since this is a failable
   operation, we need to return a `Decoded` type from this function.
   
   - parameter json: The `JSON` representation of this object
   
   - returns: A decoded instance of the `DecodedType`
   */
  public static func decode(_ json: JSON) -> Decoded<Issue> {
    return curry(Issue.init)
      <^> json <| "id"
      <*> json <| "number"
      <*> json <| "title"
      <*> json <| "body"
  }
}
