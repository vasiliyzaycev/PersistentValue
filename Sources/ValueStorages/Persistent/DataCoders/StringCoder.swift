//
//  StringCoder.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

import Foundation

public struct StringCoder: DataCoder {
  public init() {}

  public func decode(from data: Data) throws -> String {
    String(decoding: data, as: UTF8.self)
  }

  public func encode(_ value: String) throws -> Data {
    Data(value.utf8)
  }
}
