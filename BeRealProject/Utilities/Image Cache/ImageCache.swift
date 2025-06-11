import UIKit

enum ImageCacheError: Error {
    case incorrectData
    case error(String)
}

protocol ImageCacheType {
    func getImage(for url: URL) async -> Result<UIImage, ImageCacheError>
    func clearCache() async
}

actor ImageCache: ImageCacheType {
    
    init(urlSession: URLSessionType) {
        self.urlSession = urlSession
    }
    
    @MainActor
    func getImage(for url: URL) async -> Result<UIImage, ImageCacheError> {
        if let cachedImage = await cache[url] { return .success(cachedImage) }
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            guard let image = UIImage(data: data) else { return .failure(.incorrectData) }
            
            await setCache(for: image, with: url)
            return .success(image)
        } catch {
            return .failure(.error(error.localizedDescription))
        }
    }
    
    func clearCache() async {
        cache.removeAll()
    }
    
    // MARK: - Privates
    private var cache: [URL: UIImage] = [:]
    private let urlSession: URLSessionType
    
    private func setCache(for image: UIImage, with url: URL) {
        cache[url] = image
    }
}
