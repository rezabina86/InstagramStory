import Combine
import Foundation

protocol SeenPostsRepositoryType {
    var seenPosts: AnyPublisher<Set<String>, Never> { get }
    func seenPost(id: String)
}

final class SeenPostsRepository: SeenPostsRepositoryType {
    
    init(storage: SeenStorageType) {
        self.storage = storage
        updatePublisher()
    }
    
    var seenPosts: AnyPublisher<Set<String>, Never> {
        seenPostsSubject.eraseToAnyPublisher()
    }
    
    func seenPost(id: String) {
        storage.seenPost(id)
        updatePublisher()
    }
    
    // MARK: - Privates
    private let storage: SeenStorageType
    private let seenPostsSubject: CurrentValueSubject<Set<String>, Never> = .init([])
    
    private func updatePublisher() {
        let seenItems = storage.getSeenPosts()
        seenPostsSubject.send(seenItems)
    }
}


