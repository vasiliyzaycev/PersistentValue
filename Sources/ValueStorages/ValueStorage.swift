//
//  ValueStorage.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

public protocol ValueStorage<Value>: AnyObject {
  associatedtype Value: Codable

  func save(_ value: Value?) throws
  func load() throws -> Value?
}
