import Foundation

private enum SeenStorageStorageKey: String, CaseIterable {
    case seen = "seen_posts"
}

protocol SeenStorageType {
    func seenPost(_ id: String) async
    func getSeenPosts() async -> Set<String>
}

actor SeenStorage: SeenStorageType {
    
    init(userDefaults: UserDefaultsType) {
        self.userDefaults = userDefaults
    }
    
    func seenPost(_ id: String) async {
        var seenPosts = getSeenPosts()
        seenPosts.insert(id)
        userDefaults.set(Array(seenPosts), forKey: .seen)
    }
    
    func getSeenPosts() -> Set<String> {
        guard let array = userDefaults.object(forKey: .seen) as? [String] else {
            return Set<String>()
        }
        return Set(array)
    }
    
    private let userDefaults: UserDefaultsType
}

private extension UserDefaultsType {
    func set(_ value: Any?, forKey key: SeenStorageStorageKey) {
        set(value, forKey: key.rawValue)
    }
    
    func object(forKey defaultName: SeenStorageStorageKey) -> Any? {
        object(forKey: defaultName.rawValue)
    }
    
    func removeObject(forKey defaultName: SeenStorageStorageKey) {
        removeObject(forKey: defaultName.rawValue)
    }
}
