//
// Copyright © 2023 Vasiliy Zaycev. All rights reserved.
//

public protocol ErrorHandler: Sendable {
  func handle(_ error: Error)
}

public protocol CertainErrorHandler: ErrorHandler {
  associatedtype ErrorType: Error = Error
}
