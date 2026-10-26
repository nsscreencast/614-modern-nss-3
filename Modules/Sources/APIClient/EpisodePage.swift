public extension API.V2 {
    struct EpisodePage: Decodable, Hashable, Sendable {
        public let data: [Episode]
        public let meta: Metadata

        public struct Metadata: Decodable, Hashable, Sendable {
            public let nextPageCursor: Cursor<NextPage>?
            public let hasMore: Bool
            public let syncCursor: Cursor<Sync>
        }
    }
}

public enum Sync {}
public enum NextPage {}

public struct Cursor<T>: Decodable, Hashable, Sendable, CustomStringConvertible {
    var value: String

    public var description: String {
        value
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(String.self)
    }
}
