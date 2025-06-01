import Foundation

protocol JSONDecoderType {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: JSONDecoderType {}
