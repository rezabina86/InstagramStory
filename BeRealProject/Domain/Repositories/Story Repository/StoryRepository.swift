import Foundation

protocol StoryRepositoryType {
    func resourceURL(for userId: String) -> URL
}

struct StoryRepository: StoryRepositoryType {
    
    func resourceURL(for userId: String) -> URL {
        URL(string: "https://picsum.photos/id/\(userId)/400/600")!
    }
    
}
