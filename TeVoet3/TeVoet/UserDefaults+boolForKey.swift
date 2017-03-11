
//  UserDefaults+boolForKey.swift

import Foundation

extension UserDefaults {
    func boolForKey(key: String, defaultValue: Bool) -> Bool {
        let v = UserDefaults.standard.object(forKey: key)
        if v != nil {
            if let b = v as? Bool {
                return b
                }
            }
        return defaultValue
        }

    func intForKey(key: String, defaultValue: Int) -> Int {
        let v = UserDefaults.standard.object(forKey: key)
        if v != nil {
            if let i = v as? Int {
                return i
                }
            }
        return defaultValue
        }

    }
