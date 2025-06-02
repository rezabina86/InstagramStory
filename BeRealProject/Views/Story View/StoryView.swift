import SwiftUI

struct StoryView: View {
    
    @StateObject var viewModel: StoryViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    imageView(geometry: geometry)
                    gestureView(geometry: geometry)
                    VStack(spacing: 0) {
                        StoryHeaderView(viewState: viewModel.viewState.currentStory.headerViewState)
                            .padding(.top, 16)
                        Spacer()
                    }
                }
                
                HStack {
                    Spacer()
                    likeButton
                }
            }
            .onChange(of: viewModel.viewState.currentStory) { old, new in
                guard old.id != new.id else { return }
                viewModel.viewState.currentStory.onAppear.action()
            }
        }
    }
    
    @ViewBuilder
    private func imageView(geometry: GeometryProxy) -> some View {
        AsyncImage(url: URL(string: viewModel.viewState.currentStory.imageURL)) { phase in
            switch phase {
            case .empty:
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            case let .success(image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width - 1)
                    .clipped()
                    .cornerRadius(12)
            case .failure:
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: geometry.size.width - 1)
            @unknown default:
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: geometry.size.width - 1)
            }
        }
    }
    
    @ViewBuilder
    private var likeButton: some View {
        Button {
            viewModel.viewState.currentStory.onTapLike.action()
        } label: {
            Image(systemName: viewModel.viewState.currentStory.isLiked ? "heart.fill" : "heart")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.red)
                .animation(.easeInOut(duration: 0.2), value: viewModel.viewState.currentStory.isLiked)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private func gestureView(geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            // Left tap area - previous story
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.viewState.onTapLeft.action()
                }
                .frame(width: geometry.size.width * 0.4)
            
            // Right tap area - next story
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.viewState.onTapRight.action()
                }
                .frame(width: geometry.size.width * 0.4)
        }
    }
}

struct StoryViewState: Equatable {
    let currentStory: Story
    let onTapRight: UserAction
    let onTapLeft: UserAction
}

extension StoryViewState {
    struct Story: Equatable {
        let id: String
        let headerViewState: StoryHeaderViewState
        let imageURL: String
        let isLiked: Bool
        let onTapLike: UserAction
        let onAppear: UserAction
    }
}

extension StoryViewState {
    static let empty = Self(
        currentStory: .init(
            id: "",
            headerViewState: .init(
                userAvatarURL: "",
                userName: "",
                onTapClose: .fake
            ),
            imageURL: "",
            isLiked: false,
            onTapLike: .fake,
            onAppear: .fake
        ),
        onTapRight: .fake,
        onTapLeft: .fake
    )
}
