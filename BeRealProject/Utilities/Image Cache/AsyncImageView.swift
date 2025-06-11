import SwiftUI

struct AsyncImageView: View {
    
    @StateObject var viewModel: AsyncImageViewModel
    let width: CGFloat
    let height: CGFloat? = nil
    let cornerRadius: CGFloat
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                VStack {
                    Spacer()
                    ProgressView()
                        .frame(width: 50, height: 50)
                    Spacer()
                }
            case let .image(image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipped()
                    .cornerRadius(cornerRadius)
            case .error:
                Circle()
                    .fill(Color.gray.opacity(0.3))
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

