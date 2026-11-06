//
// Copyright © 2023 Vasiliy Zaycev. All rights reserved.
//

public enum KeychainAccessibility: Sendable {
  case afterFirstUnlock
  case afterFirstUnlockThisDeviceOnly
  case whenUnlocked
  case whenUnlockedThisDeviceOnly
}
