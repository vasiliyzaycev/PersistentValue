//
//  ErrorHandlers.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

public protocol ErrorHandler {
  func handle(_ error: Error)
}

public protocol CertainErrorHandler: ErrorHandler {
  associatedtype ErrorType: Error = Error
}
