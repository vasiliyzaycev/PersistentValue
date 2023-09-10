//
//  DefaultErrorHandler.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

public struct DefaultErrorHandler: ErrorHandler {
  public init() {}

  public func handle(_ error: Error) {
    print("Unexpected error: \(error).")
  }
}
