//
// Copyright © 2023 Vasiliy Zaycev. All rights reserved.
//

public struct StorageErrorHandler<T: Error>: CertainErrorHandler {
  public typealias ErrorType = T

  public let currentHandler: @Sendable (T) -> Void
  public let reserveHandler: ErrorHandler

  public init(
    reserveHandler: ErrorHandler = DefaultErrorHandler(),
    _ currentHandler: @escaping @Sendable (T) -> Void
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
