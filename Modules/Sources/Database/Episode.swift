import Foundation
import SQLiteData

@Table
public struct Episode: Hashable, Identifiable {
    public let id: Int
    public var episodeNumber: Int
    public var title: String
    public var summary: String
    public var publishedAt: Date
    public var updatedAt: Date
    public var duration: Int
    public var episodeType: String
    public var artworkSmallURL: String

    public init(
        id: Int,
        episodeNumber: Int,
        title: String,
        summary: String,
        publishedAt: Date,
        updatedAt: Date,
        duration: Int,
        episodeType: String,
        artworkSmallURL: String
    ) {
        self.id = id
        self.episodeNumber = episodeNumber
        self.title = title
        self.summary = summary
        self.publishedAt = publishedAt
        self.updatedAt = updatedAt
        self.duration = duration
        self.episodeType = episodeType
        self.artworkSmallURL = artworkSmallURL
    }
}
