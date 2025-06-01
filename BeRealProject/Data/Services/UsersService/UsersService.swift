import Foundation

protocol UsersServiceType {
    func users() async throws -> UsersAPIEntity
}

struct UsersService: UsersServiceType {
    
    init(client: HTTPClientType,
         jsonDecoder: JSONDecoderType) {
        self.client = client
        self.jsonDecoder = jsonDecoder
    }
    
    func users() async throws -> UsersAPIEntity {
        let data = try await client.load()
        let apiEntity = try jsonDecoder.decode(UsersAPIEntity.self, from: data)
        return apiEntity
    }
    
    private let client: HTTPClientType
    private let jsonDecoder: JSONDecoderType
}
