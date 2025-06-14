import Combine
import Foundation

protocol HomeViewModelFactoryType {
    func create() -> HomeViewModel
}

struct HomeViewModelFactory: HomeViewModelFactoryType {
    let storyUseCase: StoryUseCaseType
    let storyViewModelFactory: StoryViewModelFactoryType
    let modalCoordinator: ModalCoordinatorType
    
    func create() -> HomeViewModel {
        .init(storyUseCase: storyUseCase,
              storyViewModelFactory: storyViewModelFactory,
              modalCoordinator: modalCoordinator)
    }
}

final class HomeViewModel: ObservableObject {
    
    @Published var viewState: HomeViewState = .init(stories: [])
    @Published var currentDestination: ModalCoordinatorDestination? = nil
    
    init(storyUseCase: StoryUseCaseType,
         storyViewModelFactory: StoryViewModelFactoryType,
         modalCoordinator: ModalCoordinatorType) {
        storyUseCase.stories
            .map { stories in
                let stories: [StoryPreviewViewState] = stories.enumerated().map { index, story in
                    .init(
                        id: "\(story.id)",
                        userName: story.user.name,
                        userAvatarURL: story.user.profilePictureUrl,
                        seen: story.seen,
                        onTap: .init {
                            modalCoordinator.present(.story(viewModel: storyViewModelFactory.create(currentStoryIndex: index)))
                        })
                }
                return HomeViewState(stories: stories)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$viewState)
        
        
        modalCoordinator.currentDestination
            .assign(to: &$currentDestination)
    }
    
    private var currentPage: Int = 0
}

