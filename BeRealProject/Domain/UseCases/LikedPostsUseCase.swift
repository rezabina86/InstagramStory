import Foundation

protocol LikedPostsUseCaseType {
    func toggleLike(for postId: String) async
}

struct LikedPostsUseCase: LikedPostsUseCaseType {
    
    init(repository: LikedPostsRepositoryType) {
        self.repository = repository
    }
    
    func toggleLike(for postId: String) async {
        let isLiked = await repository.isLiked(id: postId)
        if isLiked {
            await repository.unlikePost(id: postId)
        } else {
            await repository.likePost(id: postId)
        }
    }
    
    private let repository: LikedPostsRepositoryType
}
