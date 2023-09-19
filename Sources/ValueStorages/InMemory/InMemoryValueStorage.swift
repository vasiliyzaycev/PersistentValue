//
//  InMemoryValueStorage.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

public final class InMemoryValueStorage<Value: Codable>: ValueStorage {
  private var value: Value?

  public init(value: Value? = nil) {
    self.value = value
  }

  public func save(_ value: Value?) throws {
    self.value = value
  }

  public func load() throws -> Value? {
    value
  }
}
