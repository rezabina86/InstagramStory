import Foundation

struct StoryModel: Equatable, Identifiable {
    let id: Int
    let user: UserModel
    let storyURL: String
    let seen: Bool
    let liked: Bool
}
