//
// Copyright © 2023 Vasiliy Zaycev. All rights reserved.
//

public struct CustomErrorHandler: ErrorHandler {
  private let handler: (Error) -> Void
  
  public init(
    handler: @escaping (Error) -> Void
  ) {
    self.handler = handler
  }

  public func handle(_ error: Error) {
    handler(error)
  }
}
