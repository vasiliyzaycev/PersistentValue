//
// Copyright © 2023 Vasiliy Zaycev. All rights reserved.
//

public final class CustomValueStorage<Value: Codable>: ValueStorage {
  private let saveClosure: (Value?) throws -> Void
  private let loadClosure: () throws -> Value?
  
  public init(
    save: @escaping (Value?) throws -> Void,
    load: @escaping () throws -> Value?
  ) {
    self.saveClosure = save
    self.loadClosure = load
  }

  public func save(_ value: Value?) throws {
    try saveClosure(value)
  }

  public func load() throws -> Value? {
    try loadClosure()
  }
}
