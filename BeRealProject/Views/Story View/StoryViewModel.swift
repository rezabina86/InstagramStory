import Combine
import Foundation

protocol StoryViewModelFactoryType {
    func create(stories: [StoryModel], currentStoryIndex: Int) -> StoryViewModel
}

struct StoryViewModelFactory: StoryViewModelFactoryType {
    let storyUseCase: StoryUseCaseType
    let modalCoordinator: ModalCoordinatorType
    let seenRepository: SeenPostsRepositoryType
    let likedPostsUseCase: LikedPostsUseCaseType
    
    func create(stories: [StoryModel], currentStoryIndex: Int) -> StoryViewModel {
        .init(currentStoryIndex: currentStoryIndex,
              storyUseCase: storyUseCase,
              modalCoordinator: modalCoordinator,
              seenRepository: seenRepository,
              likedPostsUseCase: likedPostsUseCase)
    }
}

final class StoryViewModel: ObservableObject {
    @Published var viewState: StoryViewState = .empty
    
    init(currentStoryIndex: Int,
         storyUseCase: StoryUseCaseType,
         modalCoordinator: ModalCoordinatorType,
         seenRepository: SeenPostsRepositoryType,
         likedPostsUseCase: LikedPostsUseCaseType) {
        self.currentStoryIndexSubject = .init(currentStoryIndex)
        self.modalCoordinator = modalCoordinator
        self.seenRepository = seenRepository
        self.likedPostsUseCase = likedPostsUseCase
        
        storyUseCase.stories
            .combineLatest(currentStoryIndexSubject)
            .map { [weak self] stories, currentIndex in
                guard stories.count > currentIndex else { return .empty }
                return self?.createViewState(from: stories, currentStoryIndex: currentIndex) ?? .empty
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$viewState)
    }
    
    private let currentStoryIndexSubject: CurrentValueSubject<Int, Never>
    private let modalCoordinator: ModalCoordinatorType
    private let seenRepository: SeenPostsRepositoryType
    private let likedPostsUseCase: LikedPostsUseCaseType
    
    private func createViewState(from stories: [StoryModel], currentStoryIndex: Int) -> StoryViewState {
        .init(
            currentStory: createStory(from: stories[currentStoryIndex]),
            onTapRight: .init { [weak self] in
                guard let currentIndex = self?.currentStoryIndexSubject.value,
                      currentIndex < stories.count else { return }
                self?.currentStoryIndexSubject.send(currentIndex + 1)
            },
            onTapLeft: .init { [weak self] in
                guard let currentIndex = self?.currentStoryIndexSubject.value,
                      currentIndex > 0 else { return }
                self?.currentStoryIndexSubject.send(currentIndex - 1)
            }
        )
    }
    
    private func createStory(from story: StoryModel) -> StoryViewState.Story {
        .init(
            id: "\(story.id)",
            headerViewState: .init(
                userAvatarURL: story.user.profilePictureUrl,
                userName: story.user.name,
                onTapClose: .init { [modalCoordinator] in
                    modalCoordinator.present(nil)
                }
            ),
            imageURL: story.storyURL,
            isLiked: story.liked,
            onTapLike: .init { [likedPostsUseCase] in
                Task {
                    await likedPostsUseCase.toggleLike(for: story.user.id)
                }
            },
            onAppear: .init { [seenRepository] in
                Task {
                    await seenRepository.seenPost(id: story.user.id)
                }
            }
        )
    }
}
