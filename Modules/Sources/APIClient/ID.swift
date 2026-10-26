import Foundation

public struct ID<T>: Decodable, Hashable, Sendable {
    public let value: Int

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(Int.self)
    }
}
