//
// Copyright © 2023 Vasiliy Zaycev. All rights reserved.
//

import Foundation

public enum KeychainDataStorageError: Error {
  case lookup(OSStatus)
  case update(OSStatus)
  case insert(OSStatus)
  case delete(OSStatus)
}

public struct KeychainDataStorage: DataStorage {
  private let valueKey: String
  private let service: String
  private let accessGroup: String?

  public init(
    valueKey: String,
    service: String,
    accessGroup: String? = nil
  ) {
    self.valueKey = valueKey
    self.service = service
    self.accessGroup = accessGroup
  }

  public func save(data: Data?) throws {
    guard let data = data else { return try removeData() }
    let status = SecItemCopyMatching(keyAttributes() as CFDictionary, nil)
    switch status {
    case errSecItemNotFound:  try insert(data: data)
    case errSecSuccess:       try update(data: data)
    default:                  throw KeychainDataStorageError.lookup(status)
    }
  }

  public func loadData() throws -> Data? {
    var data: AnyObject?
    let status = withUnsafeMutablePointer(to: &data) {
      SecItemCopyMatching(keyQueryAttributes() as CFDictionary, UnsafeMutablePointer($0))
    }
    guard status != errSecItemNotFound else { return nil }
    guard status == errSecSuccess else { throw KeychainDataStorageError.lookup(status) }
    return data as? Data
  }
}

private extension KeychainDataStorage {
  private func insert(data: Data) throws {
    let attributes = keyInsertAttributes(data: data)
    let status = SecItemAdd(attributes as CFDictionary, nil)
    guard status == errSecSuccess else { throw KeychainDataStorageError.insert(status) }
  }

  private func update(data: Data) throws {
    let attributes = [kSecValueData as String: data]
    let status = SecItemUpdate(keyAttributes() as CFDictionary, attributes as CFDictionary)
    guard status == errSecSuccess else { throw KeychainDataStorageError.update(status) }
  }

  private func removeData() throws {
    let status = SecItemDelete(keyAttributes() as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainDataStorageError.delete(status)
    }
  }

  private func keyQueryAttributes() -> [CFString: Any] {
    var result = keyAttributes()
    result[kSecReturnData] = kCFBooleanTrue
    result[kSecMatchLimit] = kSecMatchLimitOne
    return result
  }

  private func keyAttributes() -> [CFString: Any] {
    var result: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: valueKey
    ]
    #if !targetEnvironment(simulator)
    if let accessGroup = accessGroup {
      result[kSecAttrAccessGroup] = accessGroup
    }
    #endif
    return result
  }

  private func keyInsertAttributes(data: Data) -> [CFString: Any] {
    var result = keyAttributes()
    result[kSecAttrAccessible] = kSecAttrAccessibleAfterFirstUnlock
    result[kSecValueData] = data
    return result
  }
}
