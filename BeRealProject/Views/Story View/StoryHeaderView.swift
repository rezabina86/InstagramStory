import SwiftUI

struct StoryHeaderView: View {
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: viewState.userAvatarURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
            
            Text(viewState.userName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: viewState.onTapClose.action) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 16)
    }
    
    let viewState: StoryHeaderViewState
}

struct StoryHeaderViewState: Equatable {
    let userAvatarURL: String
    let userName: String
    let onTapClose: UserAction
}
