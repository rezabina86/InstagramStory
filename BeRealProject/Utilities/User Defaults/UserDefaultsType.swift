import Foundation

public protocol UserDefaultsType: AnyObject {
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey key: String)
    func removeObject(forKey defaultName: String)
}

extension UserDefaults: UserDefaultsType {}
