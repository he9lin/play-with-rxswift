//
//  Repository.swift
//  Smiley
//
//  Created by Lin He on 9/22/16.
//  Copyright © 2016 heroxtech. All rights reserved.
//

import Argo
import Curry
import Runes

struct Repository {
  let id: Int
  let name: String
  let language: String
  let fullName: String
}

extension Repository: Decodable {
  /**
   Decode an object from JSON.
   
   This is the main entry point for Argo. This function declares how the
   conforming type should be decoded from JSON. Since this is a failable
   operation, we need to return a `Decoded` type from this function.
   
   - parameter json: The `JSON` representation of this object
   
   - returns: A decoded instance of the `DecodedType`
   */
  public static func decode(_ json: JSON) -> Decoded<Repository> {
    return curry(Repository.init)
      <^> json <| "id"
      <*> json <| "name"
      <*> json <| "language"
      <*> json <| "full_name"
  }
}
