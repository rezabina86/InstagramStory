import Foundation

protocol LikedPostsUseCaseType {
    func toggleLike(for postId: String)
}

struct LikedPostsUseCase: LikedPostsUseCaseType {
    
    init(repository: LikedPostsRepositoryType) {
        self.repository = repository
    }
    
    func toggleLike(for postId: String) {
        let isLiked = repository.isLiked(id: postId)
        if isLiked {
            repository.unlikePost(id: postId)
        } else {
            repository.likePost(id: postId)
        }
    }
    
    private let repository: LikedPostsRepositoryType
}
