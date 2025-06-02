import SwiftUI

struct StoryPreviewView: View {
    let story: StoryPreviewViewState
    
    var body: some View {
        Button(action: story.onTap.action) {
            VStack(spacing: 8) {
                AsyncImage(url: URL(string: story.userAvatarURL)) { phase in
                    switch phase {
                    case .empty:
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                    @unknown default:
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                    }
                }
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: story.seen ? [.gray] : [.purple, .pink, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                )
                
                Text(story.userName)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .frame(width: 70)
            }
        }
    }
}

enum StoryPreviewViewStateType: Equatable, Identifiable {
    case story(viewState: StoryPreviewViewState)
    case loader(viewState: StoryPreviewLoaderViewState)
    
    var id: String {
        switch self {
        case let .story(viewState):
            return viewState.id
        case let .loader(viewState):
            return viewState.id
        }
    }
}

struct StoryPreviewViewState: Equatable {
    let id: String
    let userName: String
    let userAvatarURL: String
    let seen: Bool
    let onTap: UserAction
}

struct StoryPreviewLoaderViewState: Equatable {
    let id: String
    let onAppear: UserAction
}
