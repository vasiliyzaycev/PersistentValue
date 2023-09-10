//
//  StorageErrorHandler.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

public struct StorageErrorHandler<T: Error>: CertainErrorHandler {
  public typealias ErrorType = T

  public let currentHandler: (T) -> Void
  public let reserveHandler: ErrorHandler

  public init(
    reserveHandler: ErrorHandler = DefaultErrorHandler(),
    _ currentHandler: @escaping (T) -> Void
  ) {
    self.reserveHandler = reserveHandler
    self.currentHandler = currentHandler
  }

  public func handle(_ error: Error) {
    if let error = error as? T {
      currentHandler(error)
    } else {
      reserveHandler.handle(error)
    }
  }
}
