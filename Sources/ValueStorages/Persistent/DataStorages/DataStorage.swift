//
// Copyright © 2023 Vasiliy Zaycev. All rights reserved.
//

import Foundation

public protocol DataStorage {
  func save(data: Data?) throws
  func loadData() throws -> Data?
}
