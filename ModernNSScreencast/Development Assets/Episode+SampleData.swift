import Foundation
import APIClient

extension API.V2.Episode {
    static var sample: Self {
        let path = Bundle.main.url(forResource: "sample-episode", withExtension: "json")!
        let data = try! Data(contentsOf: path)
        let decoder = APIClient.decoder
        return try! decoder.decode(API.V2.Episode.self, from: data)
    }
}
