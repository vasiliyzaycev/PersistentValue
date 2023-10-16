//
// Copyright © 2023 Vasiliy Zaycev. All rights reserved.
//

public protocol ValueStorage<Value>: AnyObject {
  associatedtype Value: Codable

  func save(_ value: Value?) throws
  func load() throws -> Value?
}
