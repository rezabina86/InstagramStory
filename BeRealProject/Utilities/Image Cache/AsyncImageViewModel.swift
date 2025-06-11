import SwiftUI
import Foundation

protocol AsyncImageViewModelFactoryType {
    func create(with url: URL) -> AsyncImageViewModel
}

struct AsyncImageViewModelFactory: AsyncImageViewModelFactoryType {
    let imageCache: ImageCacheType
    
    func create(with url: URL) -> AsyncImageViewModel {
        .init(url: url,
              imageCache: imageCache)
    }
}

final class AsyncImageViewModel: ObservableObject {
    
    @Published var state: AsyncImageState = .loading
    let url: URL
    
    init(url: URL,
         imageCache: ImageCacheType) {
        self.url = url
        self.imageCache = imageCache
    }
    
    @MainActor
    func load() async {
        state = .loading
        let result = await imageCache.getImage(for: url)
        switch result {
        case let .success(image):
            state = .image(Image(uiImage: image))
        case .failure:
            state = .error
        }
    }
    
    // MARK: - Privates
    private let imageCache: ImageCacheType
}

extension AsyncImageViewModel: Equatable {
    static func == (lhs: AsyncImageViewModel, rhs: AsyncImageViewModel) -> Bool {
        lhs.url == rhs.url
    }
}

enum AsyncImageState: Equatable {
    case loading
    case image(Image)
    case error
}
