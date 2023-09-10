//
//  DataStorage.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

import Foundation

public protocol DataStorage {
  associatedtype ErrorType: Error

  func save(data: Data?) throws
  func loadData() throws -> Data?
}
