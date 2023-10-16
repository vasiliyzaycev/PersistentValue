//
// Copyright © 2023 Vasiliy Zaycev. All rights reserved.
//

@propertyWrapper
public struct Persisted<Value: Codable> {
  private let persistentValue: PersistentValue<Value>
  private let errorHandler: ErrorHandler

  public var wrappedValue: Value? {
    get {
      persistentValue.value
    }
    nonmutating set {
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

  public init(
    persistentValue: PersistentValue<Value>,
    errorHandler: ErrorHandler
  ) {
    self.persistentValue = persistentValue
    self.errorHandler = errorHandler
  }
}
