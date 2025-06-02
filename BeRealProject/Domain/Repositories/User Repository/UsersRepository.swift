import Combine
import Foundation

protocol UsersRepositoryType {
    func load(page: Int) async throws
    var users: AnyPublisher<[UserModel], Never> { get }
}

final class UsersRepository: UsersRepositoryType {
    
    init(usersCache: UsersCacheType) {
        self.usersCache = usersCache
    }
    
    var users: AnyPublisher<[UserModel], Never> {
        usersSubject.eraseToAnyPublisher()
    }
    
    func load(page: Int) async throws {
        let allPages = try await usersCache.getPages()
        appendPageUsers(page: page, allPages: allPages)
    }
    
    private let usersCache: UsersCacheType
    private let usersSubject: CurrentValueSubject<[UserModel], Never> = .init([])
    
    private func appendPageUsers(page: Int, allPages: [UsersAPIEntity.Page]) {
        guard !allPages.isEmpty else { return }
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
