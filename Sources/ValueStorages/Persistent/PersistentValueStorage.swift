//
//  PersistentValueStorage.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

public final class PersistentValueStorage<Value: Codable>: ValueStorage {
  private let saveValue: (Value?) throws -> Void
  private let loadValue: () throws -> Value?

  public init<DC: DataCoder, DS: DataStorage>(
    dataCoder: DC,
    dataStorage: DS
  ) where DC.Value == Value {
    self.saveValue = { value in
      try dataStorage.save(data: try value.map(dataCoder.encode))
    }
    self.loadValue = {
      try dataStorage.loadData().map(dataCoder.decode(from:))
    }
  }

  public func save(_ value: Value?) throws {
    try saveValue(value)
  }

  public func load() throws -> Value? {
    try loadValue()
  }
}

extension PersistentValueStorage {
  public convenience init<DS: DataStorage>(dataStorage: DS) {
    self.init(dataCoder: JSONCoder<Value>(), dataStorage: dataStorage)
  }
}
