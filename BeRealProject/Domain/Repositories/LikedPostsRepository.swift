import Combine
import Foundation

protocol LikedPostsRepositoryType {
    var likedPosts: AnyPublisher<Set<String>, Never> { get }
    func likePost(id: String)
    func unlikePost(id: String)
    func isLiked(id: String) -> Bool
}

final class LikedPostsRepository: LikedPostsRepositoryType {
    
    init(storage: LikedItemsStorageType) {
        self.storage = storage
        updatePublisher()
    }
    
    var likedPosts: AnyPublisher<Set<String>, Never> {
        likedPostsSubject.eraseToAnyPublisher()
    }
    
    func likePost(id: String) {
        storage.addLikedItem(id)
        updatePublisher()
    }
    
    func unlikePost(id: String) {
        storage.removeLikedItem(id)
        updatePublisher()
    }
    
    func isLiked(id: String) -> Bool {
        storage.isLiked(id)
    }
    
    // MARK: - Privates
    private let storage: LikedItemsStorageType
    private let likedPostsSubject: CurrentValueSubject<Set<String>, Never> = .init([])
    
    private func updatePublisher() {
        let likedItems = storage.getLikedPosts()
        likedPostsSubject.send(likedItems)
    }
}


