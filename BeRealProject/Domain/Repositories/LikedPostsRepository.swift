import Combine
import Foundation

protocol LikedPostsRepositoryType {
    var likedPosts: AnyPublisher<Set<String>, Never> { get }
    func likePost(id: String) async
    func unlikePost(id: String) async
    func isLiked(id: String) async -> Bool
}

final class LikedPostsRepository: LikedPostsRepositoryType {
    
    init(storage: LikedItemsStorageType) {
        self.storage = storage
        Task {
            await updatePublisher()
        }
    }
    
    var likedPosts: AnyPublisher<Set<String>, Never> {
        likedPostsSubject.eraseToAnyPublisher()
    }
    
    func likePost(id: String) async {
        await storage.addLikedItem(id)
        await updatePublisher()
    }
    
    func unlikePost(id: String) async {
        await storage.removeLikedItem(id)
        await updatePublisher()
    }
    
    func isLiked(id: String) async -> Bool {
        await storage.isLiked(id)
    }
    
    // MARK: - Privates
    private let storage: LikedItemsStorageType
    private let likedPostsSubject: CurrentValueSubject<Set<String>, Never> = .init([])
    
    private func updatePublisher() async {
        let likedItems = await storage.getLikedPosts()
        likedPostsSubject.send(likedItems)
    }
}


