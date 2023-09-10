//
//  PersistingPublished.swift
//  PersistentValue
//
//  Created by Vasiliy Zaytsev.
//

import Combine

@MainActor
@propertyWrapper
public struct PersistingPublished<V: Codable> {
  public typealias Value = V?
  public typealias Publisher = AnyPublisher<Value, Never>

  @Persisted<V>
  public var wrappedValue: V? { willSet { parent.objectWillChange?() } }
  public var projectedValue: Publisher { mutating get { $wrappedValue.valuePublisher } }

  private let parent = Holder()

  public init(_ persistedValue: Persisted<V>) {
    self._wrappedValue = persistedValue
  }

  public static subscript<EnclosingSelf: ObservableObject>(
    _enclosingInstance instance: EnclosingSelf,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
    storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
  ) -> Value where EnclosingSelf.ObjectWillChangePublisher == ObservableObjectPublisher {
    get {
      let wrapper = instance[keyPath: storageKeyPath]
      wrapper.setParent(instance)
      return wrapper.wrappedValue
    }
    set {
      var wrapper = instance[keyPath: storageKeyPath]
      wrapper.setParent(instance)
      wrapper.wrappedValue = newValue
    }
  }

  public static subscript<EnclosingSelf: ObservableObject>(
    _enclosingInstance instance: EnclosingSelf,
    projected wrappedKeyPath: KeyPath<EnclosingSelf, Publisher>,
    storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
  ) -> Publisher where EnclosingSelf.ObjectWillChangePublisher == ObservableObjectPublisher {
    var wrapper = instance[keyPath: storageKeyPath]
    wrapper.setParent(instance)
    return wrapper.projectedValue
  }

  private func setParent<Parent: ObservableObject>(
    _ parentObject: Parent
  ) where Parent.ObjectWillChangePublisher == ObservableObjectPublisher {
    guard parent.objectWillChange == nil else { return }
    self.parent.objectWillChange = { [weak parentObject] in
      parentObject?.objectWillChange.send()
    }
  }

  private class Holder {
    var objectWillChange: (() -> Void)?
  }
}
