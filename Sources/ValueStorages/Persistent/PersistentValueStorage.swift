//
// Copyright © 2023 Vasiliy Zaycev. All rights reserved.
//

public final class PersistentValueStorage<Value: Codable>: ValueStorage {
  private let dataCoder: any DataCoder<Value>
  private let dataStorage: any DataStorage

  public init(
    dataCoder: some DataCoder<Value>,
    dataStorage: some DataStorage
  ) {
    self.dataCoder = dataCoder
    self.dataStorage = dataStorage
  }

  public func save(_ value: Value?) throws {
    try dataStorage.save(data: try value.map(dataCoder.encode))
  }

  public func load() throws -> Value? {
    try dataStorage.loadData().map(dataCoder.decode(from:))
  }
}

extension PersistentValueStorage {
  public convenience init(dataStorage: some DataStorage) {
    self.init(dataCoder: JSONCoder<Value>(), dataStorage: dataStorage)
  }
}
