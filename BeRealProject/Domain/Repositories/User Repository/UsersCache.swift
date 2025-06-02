import Foundation

protocol UsersCacheType {
    func getPages() async throws -> [UsersAPIEntity.Page]
}

actor UsersCache: UsersCacheType {
    
    init(service: UsersServiceType) {
        self.service = service
    }
    
    func getPages() async throws -> [UsersAPIEntity.Page] {
        try await loadUsersIfNecessary()
        return allPages
    }
    
    // MARK: - Privates
    private let service: UsersServiceType
    private var allPages: [UsersAPIEntity.Page] = []
    
    private func loadUsersIfNecessary() async throws {
        guard allPages.isEmpty else { return }
        let apiEntity = try await service.users()
        self.allPages = apiEntity.pages
    }
}

