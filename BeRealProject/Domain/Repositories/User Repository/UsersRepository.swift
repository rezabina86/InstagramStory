import Combine
import Foundation

protocol UsersRepositoryType {
    var users: AnyPublisher<[UserModel], Never> { get }
}

final class UsersRepository: UsersRepositoryType {
    
    init(service: UsersServiceType) {
        self.service = service
    }
    
    var users: AnyPublisher<[UserModel], Never> {
        Future<[UserModel], Never> { promise in
            Task { [weak self] in
                guard let self else { return }
                do {
                    let users = try await service.users().pages
                        .flatMap { $0.users }
                        .map { UserModel(from: $0) }
                    promise(.success(users))
                } catch {
                    promise(.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private let service: UsersServiceType
    private let usersSubject: CurrentValueSubject<[UserModel], Never> = .init([])
}

private extension UserModel {
    init(from apiEntity: UsersAPIEntity.Page.User) {
        self.init(id: "\(apiEntity.id)",
                  name: apiEntity.name,
                  profilePictureUrl: apiEntity.profilePictureUrl)
    }
}
