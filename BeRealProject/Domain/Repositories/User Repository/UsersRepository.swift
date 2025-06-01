import Combine
import Foundation

protocol UsersRepositoryType {
    func load(page: Int)
    var users: AnyPublisher<[UserModel], Never> { get }
}

final class UsersRepository: UsersRepositoryType {
    
    init(service: UsersServiceType) {
        self.service = service
        Task {
            try await loadUsersIfNecessary()
        }
    }
    
    var users: AnyPublisher<[UserModel], Never> {
        usersSubject.eraseToAnyPublisher()
    }
    
    // Not ideal, but within a short time (4 hours), I came up with this solution
    func load(page: Int) {
        Task {
            do {
                try await loadUsersIfNecessary()
                appendPageUsers(page: page)
            } catch {
                // Handle error gracefully - could log or emit empty state - Not in the scope of this task
                print("Failed to load page \(page): \(error)")
            }
        }
    }
    
    private let service: UsersServiceType
    private let usersSubject: CurrentValueSubject<[UserModel], Never> = .init([])
    private var allPages: [UsersAPIEntity.Page] = []
    
    private func loadUsersIfNecessary() async throws {
        guard allPages.isEmpty else { return }
        let apiEntity = try await service.users()
        await MainActor.run {
            self.allPages = apiEntity.pages
            appendPageUsers(page: 0)
        }
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
