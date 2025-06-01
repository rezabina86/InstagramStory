import Combine
import Foundation

enum ModalCoordinatorDestination: Identifiable {
    case story(viewModel: StoryViewModel)
    
    var id: String {
        switch self {
        case .story:
            "story_view"
        }
    }
}

protocol ModalCoordinatorType {
    func present(_ destination: ModalCoordinatorDestination?)
    var currentDestination: AnyPublisher<ModalCoordinatorDestination?, Never> { get }
}

final class ModalCoordinator: ModalCoordinatorType {
    
    var currentDestination: AnyPublisher<ModalCoordinatorDestination?, Never> {
        currentDestinationSubject.eraseToAnyPublisher()
    }
    
    func present(_ destination: ModalCoordinatorDestination?) {
        currentDestinationSubject.send(destination)
    }
    
    // MARK: - Privates
    private let currentDestinationSubject: CurrentValueSubject<ModalCoordinatorDestination?, Never> = .init(nil)
}
