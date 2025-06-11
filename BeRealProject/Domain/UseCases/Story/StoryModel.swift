import Foundation

struct StoryModel: Equatable, Identifiable {
    let id: Int
    let user: UserModel
    let storyURL: URL
    let seen: Bool
    let liked: Bool
}
