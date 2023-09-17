//
//  DataStorage.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

import Foundation

public protocol DataStorage {
  func save(data: Data?) throws
  func loadData() throws -> Data?
}
