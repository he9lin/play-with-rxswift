//
//  OptionalType.swift
//  Smiley
//
//  Created by Lin He on 9/23/16.
//  Copyright © 2016 heroxtech. All rights reserved.
//

import Foundation

// Originially from here: https://github.com/artsy/eidolon/blob/24e36a69bbafb4ef6dbe4d98b575ceb4e1d8345f/Kiosk/Observable%2BOperators.swift#L30-L40
// Credit to Artsy and @ashfurrow

public protocol OptionalType {
  associatedtype Wrapped
  var value: Wrapped? { get }
}

extension Optional: OptionalType {
  /// Cast `Optional<Wrapped>` to `Wrapped?`
  public var value: Wrapped? {
    return self
  }
}
