import APIClient
import Database
import Foundation

extension Database.Episode.Draft {
    init(remote: API.V2.Episode) {
        let episode = Episode(
            id: remote.id.value,
            episodeNumber: remote.episodeNumber,
            title: remote.title,
            summary: remote.description,
            publishedAt: remote.publishedAt,
            updatedAt: remote.updatedAt,
            duration: remote.duration,
            episodeType: remote.episodeType.rawValue,
            artworkSmallURL: remote.artworkUrls.small.absoluteString
        )
        self.init(episode)
    }
}
