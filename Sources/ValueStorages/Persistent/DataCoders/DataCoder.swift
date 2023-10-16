//
// Copyright © 2023 Vasiliy Zaycev. All rights reserved.
//

import Foundation

public protocol DataCoder<Value> {
  associatedtype Value: Codable

  func decode(from: Data) throws -> Value
  func encode(_ value: Value) throws -> Data
}
