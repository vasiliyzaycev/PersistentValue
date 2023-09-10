//
//  ValueStorage.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

public protocol ValueStorage: AnyObject {
  associatedtype Value: Codable
  associatedtype ErrorType: Error

  func save(_ value: Value?) throws
  func load() throws -> Value?
}
