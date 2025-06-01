import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.viewState.stories) { story in
                        switch story {
                        case let .story(viewState):
                            StoryPreviewView(story: viewState)
                        case let .loader(viewState):
                            Text("")
                                .onAppear(perform: viewState.onAppear.action)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 20)
            
            Spacer()
            
            Text("Tap a story to view")
                .font(.title2)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .fullScreenCover(item: $viewModel.currentDestination) { destination in
            switch destination {
            case let .story(viewModel):
                StoryView(viewModel: viewModel)
            }
        }
    }
    
    @StateObject var viewModel: HomeViewModel
}

struct HomeViewState: Equatable {
    let stories: [StoryPreviewViewStateType]
}
