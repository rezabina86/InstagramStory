import Combine
import Foundation

protocol SeenPostsRepositoryType {
    var seenPosts: AnyPublisher<Set<String>, Never> { get }
    func seenPost(id: String) async
}

final class SeenPostsRepository: SeenPostsRepositoryType {
    
    init(storage: SeenStorageType) {
        self.storage = storage
        Task {
            await loadInitialState()
        }
    }
    
    var seenPosts: AnyPublisher<Set<String>, Never> {
        seenPostsSubject.eraseToAnyPublisher()
    }
    
    func seenPost(id: String) async {
        await storage.seenPost(id)
        await updatePublisher()
    }
    
    // MARK: - Privates
    private let storage: SeenStorageType
    private let seenPostsSubject: CurrentValueSubject<Set<String>, Never> = .init([])
    
    private func loadInitialState() async {
        let seenItems = await storage.getSeenPosts()
        seenPostsSubject.send(seenItems)
    }
    
    private func updatePublisher() async {
        let seenItems = await storage.getSeenPosts()
        seenPostsSubject.send(seenItems)
    }
}


