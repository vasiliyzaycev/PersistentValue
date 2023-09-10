//
//  Persisted.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

@propertyWrapper
public struct Persisted<Value: Codable> {
  private let persistentValue: PersistentValue<Value, Error>
  private let errorHandler: ErrorHandler

  public var wrappedValue: Value? {
    get {
      persistentValue.value
    }
    set {
      do {
        try persistentValue.update(value: newValue)
      } catch {
        errorHandler.handle(error)
      }
    }
  }

  public var projectedValue: PersistentValue<Value, Error> {
    persistentValue
  }

  public init<T: CertainErrorHandler, E>(
    persistentValue: PersistentValue<Value, E>,
    errorHandler: T
  ) where T.ErrorType == E {
    self.persistentValue = persistentValue.eraseToAnyError()
    self.errorHandler = errorHandler
  }
}
