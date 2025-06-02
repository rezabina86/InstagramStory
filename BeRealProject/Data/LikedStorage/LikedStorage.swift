import Foundation

private enum LikedItemsStorageKey: String, CaseIterable {
    case liked = "liked_posts"
}

protocol LikedItemsStorageType {
    func addLikedItem(_ id: String) async
    func removeLikedItem(_ id: String) async
    func getLikedPosts() async -> Set<String> 
    func isLiked(_ id: String) async -> Bool 
}

actor LikedItemsStorage: LikedItemsStorageType {
    
    init(userDefaults: UserDefaultsType) {
        self.userDefaults = userDefaults
    }
    
    func addLikedItem(_ id: String) {
        var likedItems = getLikedPosts()
        likedItems.insert(id)
        userDefaults.set(Array(likedItems), forKey: .liked)
    }
    
    func removeLikedItem(_ id: String) {
        var likedItems = getLikedPosts()
        likedItems.remove(id)
        if likedItems.isEmpty {
            userDefaults.removeObject(forKey: .liked)
        } else {
            userDefaults.set(Array(likedItems), forKey: .liked)
        }
    }
    
    func getLikedPosts() -> Set<String> {
        guard let array = userDefaults.object(forKey: .liked) as? [String] else {
            return Set<String>()
        }
        return Set(array)
    }
    
    func isLiked(_ id: String) -> Bool {
        return getLikedPosts().contains(id)
    }
    
    private let userDefaults: UserDefaultsType
}

private extension UserDefaultsType {    
    func set(_ value: Any?, forKey key: LikedItemsStorageKey) {
        set(value, forKey: key.rawValue)
    }
    
    func object(forKey defaultName: LikedItemsStorageKey) -> Any? {
        object(forKey: defaultName.rawValue)
    }
    
    func removeObject(forKey defaultName: LikedItemsStorageKey) {
        removeObject(forKey: defaultName.rawValue)
    }
}
