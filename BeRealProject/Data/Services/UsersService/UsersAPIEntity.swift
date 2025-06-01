import Foundation

struct UsersAPIEntity: Decodable {
    let pages: [Page]
}

extension UsersAPIEntity {
    struct Page: Decodable {
        let users: [User]
    }
}

extension UsersAPIEntity.Page {
    struct User: Decodable {
        let id: Int
        let name: String
        let profilePictureUrl: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case profilePictureUrl = "profile_picture_url"
        }
    }
}


