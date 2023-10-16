//
// Copyright © 2023 Vasiliy Zaycev. All rights reserved.
//

import Combine
import Foundation

public final class PersistentValue<Value: Codable>: @unchecked Sendable {
  public var value: Value? {
    var result: Value?
    queue.sync {
      result = wrappedValue
    }
    return result
  }
  public var valuePublisher: AnyPublisher<Value?, Never> { valueSubject.eraseToAnyPublisher() }

  private var _value: Value? = nil { didSet { valueSubject.value = wrappedValue } }
  private var wrappedValue: Value? { _value ?? defaultValue }
  private let valueStorage: any ValueStorage<Value>
  private let valueSubject: CurrentValueSubject<Value?, Never>
  private let defaultValue: Value?
  private let queue = DispatchQueue(
    label: "com.queue.value.persistent",
    qos: .userInitiated,
    attributes: .concurrent
  )

  public convenience init(
    loadableValueStorage: some ValueStorage<Value>,
    defaultValue: Value? = nil
  ) throws {
    self.init(valueStorage: loadableValueStorage, defaultValue: defaultValue)
    try self.reload()
  }

  public init(
    valueStorage: some ValueStorage<Value>,
    defaultValue: Value?
  ) {
    self.valueStorage = valueStorage
    self.valueSubject = .init(defaultValue)
    self.defaultValue = defaultValue
    valueSubject.value = wrappedValue
  }

  public func update(
    value closure: @autoclosure @escaping () throws -> Value?,
    force: Bool = false
  ) throws {
    try update({ _ in try closure() }, force: force)
  }

  public func update(
    _ closure: @escaping (Value?) throws -> Value?,
    force: Bool = false
  ) throws {
    try queue.sync(flags: .barrier) { [weak self] in
      guard let self = self else { return }
      let newValue = try closure(self._value)
      try self.update(with: newValue, force: force)
    }
  }

  /// Isn't thread safe
  public func reload() throws {
    self._value = try valueStorage.load()
  }

  /// Isn't thread safe
  public func reloadIgnoringErrors() {
    do { try reload() } catch {}
  }
}

private extension PersistentValue {
  private func update(with newValue: Value?, force: Bool) throws {
    try setup(newValue: newValue, force: force)
  }

  private func update(with newValue: Value?, force: Bool) throws where Value: Equatable {
    guard _value != newValue else { return }
    try setup(newValue: newValue, force: force)
  }

  private func setup(newValue: Value?, force: Bool) throws {
    do {
      try valueStorage.save(newValue)
    } catch {
      if !force { throw error }
    }
    self._value = newValue
  }
}
