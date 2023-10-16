//
// Copyright © 2023 Vasiliy Zaycev. All rights reserved.
//

import Foundation

public struct JSONCoder<Value: Codable>: DataCoder {
  private let decoder: JSONDecoder
  private let encoder: JSONEncoder

  public init(
    decoder: JSONDecoder = JSONDecoder(),
    encoder: JSONEncoder = JSONEncoder()
  ) {
    self.decoder = decoder
    self.encoder = encoder
  }

  public func decode(from data: Data) throws -> Value {
    try decoder.decode(Value.self, from: data)
  }

  public func encode(_ value: Value) throws -> Data {
    try encoder.encode(value)
  }
}
