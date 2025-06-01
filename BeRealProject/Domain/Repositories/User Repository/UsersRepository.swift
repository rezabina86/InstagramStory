import Combine
import Foundation

protocol UsersRepositoryType {
    func load(page: Int) async throws
    var users: AnyPublisher<[UserModel], Never> { get }
}

final class UsersRepository: UsersRepositoryType {
    
    init(service: UsersServiceType) {
        self.service = service
    }
    
    var users: AnyPublisher<[UserModel], Never> {
        usersSubject.eraseToAnyPublisher()
    }
    
    func load(page: Int) async throws {
        try await loadUsersIfNecessary()
        appendPageUsers(page: page)
    }
    
    private let service: UsersServiceType
    private let usersSubject: CurrentValueSubject<[UserModel], Never> = .init([])
    private var allPages: [UsersAPIEntity.Page] = []
    
    private func loadUsersIfNecessary() async throws {
        guard allPages.isEmpty else { return }
        let apiEntity = try await service.users()
        self.allPages = apiEntity.pages
    }
    
    private func appendPageUsers(page: Int) {
        let pageIndex = page % allPages.count
        let users = allPages[pageIndex].users.map { UserModel(from: $0) }
        var loadedUsers = usersSubject.value
        loadedUsers.append(contentsOf: users)
        usersSubject.send(loadedUsers)
    }
}

private extension UserModel {
    init(from apiEntity: UsersAPIEntity.Page.User) {
        self.init(id: "\(apiEntity.id)",
                  name: apiEntity.name,
                  profilePictureUrl: apiEntity.profilePictureUrl)
    }
}
