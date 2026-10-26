import Foundation

public extension API.V2 {
    struct Episode: Identifiable, Decodable, Hashable, Sendable {
        public let id: ID<Episode>
        public let episodeNumber: Int
        public let title: String
        public let slug: String
        public let description: String
        public let publishedAt: Date
        public let updatedAt: Date
        public let duration: Int
        public let episodeType: EpisodeType
        public let artworkUrls: ImageSet
        public let videoUrl: URL
        public let subtitleUrl: URL?
        public let hlsUrl: URL?
        public let webUrl: URL
        public let showNotesUrl: URL
        public let downloadSizeBytes: Int
        public let tags: [String]
        public let versionTags: [String]
        public let seriesIds: [Int]
    }

    enum EpisodeType: String, Decodable, Hashable, Sendable {
        case free
        case paid
    }

    struct ImageSet: Decodable, Hashable, Sendable {
        public let small: URL
        public let medium: URL
        public let large: URL
    }
}
