//
//  Persisted.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

@propertyWrapper
public struct Persisted<Value: Codable> {
  private let persistentValue: PersistentValue<Value>
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

  public var projectedValue: PersistentValue<Value> {
    persistentValue
  }

  public init<T: CertainErrorHandler>(
    persistentValue: PersistentValue<Value>,
    errorHandler: T
  ) {
    self.persistentValue = persistentValue
    self.errorHandler = errorHandler
  }
}
