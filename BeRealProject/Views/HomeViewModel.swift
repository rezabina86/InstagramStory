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
                let storiesState = stories.enumerated().map { index, story in
                    StoryPreviewViewStateType.story(viewState: .init(
                            id: "\(story.id)",
                            userName: story.user.name,
                            userAvatarURL: story.user.profilePictureUrl,
                            seen: story.seen,
                            onTap: .init {
                                modalCoordinator.present(.story(viewModel: storyViewModelFactory.create(currentStoryIndex: index)))
                            })
                        )
                    }
                
                let loaderCellState: StoryPreviewViewStateType = .loader(
                    viewState: .init(
                        id: "loader_cell",
                        onAppear: .init {
                            Task { [weak self] in
                                guard let self else { return }
                                try await storyUseCase.append(page: currentPage)
                                currentPage += 1
                            }
                        }
                    )
                )
                
                return HomeViewState(stories: storiesState + [loaderCellState])
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$viewState)
        
        
        modalCoordinator.currentDestination
            .assign(to: &$currentDestination)
    }
    
    private var currentPage: Int = 0
}

