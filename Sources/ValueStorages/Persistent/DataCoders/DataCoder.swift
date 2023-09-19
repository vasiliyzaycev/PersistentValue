//
//  DataCoder.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

import Foundation

public protocol DataCoder<Value> {
  associatedtype Value: Codable

  func decode(from: Data) throws -> Value
  func encode(_ value: Value) throws -> Data
}
