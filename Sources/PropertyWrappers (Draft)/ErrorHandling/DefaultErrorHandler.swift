//
// Copyright © 2023 Vasiliy Zaycev. All rights reserved.
//

public struct DefaultErrorHandler: ErrorHandler {
  public init() {}

  public func handle(_ error: Error) {
    print("Unexpected error: \(error).")
  }
}
