//
//  PersistentValue.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

import Combine
import Foundation

public final class PersistentValue<Value, ErrorType: Error>: @unchecked Sendable {
  public var value: Value? {
    var result: Value?
    queue.sync {
      result = wrappedValue
    }
    return result
  }
  public var valuePublisher: AnyPublisher<Value?, Never> { valueSubject.eraseToAnyPublisher() }

  private var _value: Value? { didSet { valueSubject.value = wrappedValue } }
  private var wrappedValue: Value? { _value ?? defaultValue }
  private let valueSubject: CurrentValueSubject<Value?, Never>
  private let load: () throws -> Value?
  private let save: (Value?) throws -> Void
  private let defaultValue: Value?
  private let queue = DispatchQueue(
    label: "com.queue.value.persistent",
    qos: .userInitiated,
    attributes: .concurrent
  )

  public convenience init<T: ValueStorage>(
    loadableValueStorage: T,
    defaultValue: Value? = nil
  ) throws where T.Value == Value, T.ErrorType == ErrorType {
    self.init(valueStorage: loadableValueStorage, defaultValue: defaultValue)
    try self.reload()
  }

  public convenience init<T: ValueStorage>(
    valueStorage: T,
    defaultValue: Value? = nil
  ) where T.Value == Value, T.ErrorType == ErrorType {
    self.init(
      load: valueStorage.load,
      save: valueStorage.save,
      defaultValue: defaultValue
    )
  }

  private init(
    load: @escaping () throws -> Value?,
    save: @escaping (Value?) throws -> Void,
    defaultValue: Value?,
    value: Value? = nil
  ) {
    self.load = load
    self.save = save
    self.defaultValue = defaultValue
    self.valueSubject = .init(defaultValue)
    self._value = value
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
    self._value = try load()
  }

  /// Isn't thread safe
  public func reloadIgnoringErrors() {
    do { try reload() } catch {}
  }
}

public extension PersistentValue {
  func eraseToAnyError() -> PersistentValue<Value, Error> {
    .init(load: load, save: save, defaultValue: defaultValue, value: value)
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
      try save(newValue)
    } catch {
      if !force { throw error }
    }
    self._value = newValue
  }
}
