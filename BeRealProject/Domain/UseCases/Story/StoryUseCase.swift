import Combine
import Foundation

protocol StoryUseCaseType {
    var stories: AnyPublisher<[StoryModel], Never> { get }
    func load(page: Int)
}

struct StoryUseCase: StoryUseCaseType {
    
    init(usersRepository: UsersRepositoryType,
         likedRepository: LikedPostsRepositoryType,
         seenRepository: SeenPostsRepositoryType,
         storyRepository: StoryRepositoryType) {
        self.usersRepository = usersRepository
        self.likedRepository = likedRepository
        self.seenRepository = seenRepository
        self.storyRepository = storyRepository
    }
    
    var stories: AnyPublisher<[StoryModel], Never> {
        Publishers.CombineLatest3(
            usersRepository.users,
            likedRepository.likedPosts,
            seenRepository.seenPosts
        )
        .map { users, likedStories, seenStories in
            users.enumerated().map { index, user in
                StoryModel(
                    id: index,
                    user: user,
                    storyURL: storyRepository.resourceURL(for: user.id),
                    seen: seenStories.contains(user.id),
                    liked: likedStories.contains(user.id)
                )
            }
        }
        .eraseToAnyPublisher()
    }
    
    func load(page: Int) {
        usersRepository.load(page: page)
    }
    
    private let usersRepository: UsersRepositoryType
    private let likedRepository: LikedPostsRepositoryType
    private let seenRepository: SeenPostsRepositoryType
    private let storyRepository: StoryRepositoryType
}
