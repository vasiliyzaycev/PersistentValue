//
//  FileDataStorage.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

import Foundation

public struct FileDataStorageError: Error {
  public let reason: Error
  public let isFileExists: Bool
  public let isDirectory: Bool
  public let attributes: [FileAttributeKey: Any]?
}

public final class FileDataStorage: DataStorage {
  private let fileManager: FileManager
  private let fileURL: URL

  init(
    fileURL: URL,
    fileManager: FileManager = .default
  ) {
    self.fileURL = fileURL
    self.fileManager = fileManager
  }

  public func save(data: Data?) throws {
    do {
      guard let data = data else {
        try fileManager.removeItem(at: fileURL)
        return
      }
      try data.write(to: fileURL, options: .atomic)
    } catch {
      throw wrap(error: error)
    }
  }

  public func loadData() throws -> Data? {
    guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
    do {
      return try Data(contentsOf: fileURL, options: .mappedIfSafe)
    } catch {
      throw wrap(error: error)
    }
  }
}

private extension FileDataStorage {
  private func wrap(error: Error) -> FileDataStorageError {
    var isDirectory = ObjCBool(false)
    let isFileExists = fileManager.fileExists(atPath: fileURL.path, isDirectory: &isDirectory)
    return FileDataStorageError(
      reason: error,
      isFileExists: isFileExists,
      isDirectory: isDirectory.boolValue,
      attributes: try? fileManager.attributesOfFileSystem(forPath: fileURL.path)
    )
  }
}
