//
//  UserDefaultsDataStorage.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

import Foundation

public enum UserDefaultsDataStorageError: Error {
  case failedSynchronize
  case storageDataTypeMismatch
}

public final class UserDefaultsDataStorage: DataStorage {
  private let userDefaults: UserDefaults
  private let valueKey: String

  public init(
    userDefaults: UserDefaults = .standard,
    valueKey: String
  ) {
    self.userDefaults = userDefaults
    self.valueKey = valueKey
  }

  public func save(data: Data?) throws {
    userDefaults.setValue(data, forKey: valueKey)
  }

  public func loadData() throws -> Data? {
    guard let object = userDefaults.object(forKey: valueKey) else {
      return nil
    }
    guard let data = object as? Data else {
      throw UserDefaultsDataStorageError.storageDataTypeMismatch
    }
    return data
  }
}
