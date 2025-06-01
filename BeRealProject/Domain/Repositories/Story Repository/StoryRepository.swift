import Foundation

protocol StoryRepositoryType {
    func resourceURL(for userId: String) -> String
}

struct StoryRepository: StoryRepositoryType {
    
    func resourceURL(for userId: String) -> String {
        "https://picsum.photos/id/\(userId)/400/600"
    }
    
}
