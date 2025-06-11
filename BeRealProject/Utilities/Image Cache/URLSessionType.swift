import Foundation

public protocol URLSessionType {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionType {}
