import SwiftUI
import APIClient

@MainActor
@Observable
final class EpisodeListModel {
    let api = APIClient()

    enum State: Hashable {
        case idle
        case loading
        case loaded([API.V2.Episode])
        case error(String)
    }

    private(set) var state: State = .idle

    func load() async {
        guard state != .loading else { return }
        state = .loading
        do {
            let episodes = try await api.fetchEpisodePage()
            try Task.checkCancellation()
            state = .loaded(episodes.data)
        } catch is CancellationError {
            state = .idle
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func retry() async {
        state = .idle
        await load()
    }
}

struct EpisodeListView: View {
    @State var model = EpisodeListModel()

    var body: some View {
        ZStack {
            switch model.state {
            case .idle, .loading:
                ProgressView {
                    Text("Loading Episodes...")
                }
            case .loaded(let episodes):
                EpisodeList(episodes: episodes)
            case .error(let msg):
                ContentUnavailableView {
                    Label("Error loading episodes", systemImage: "wifi.exclamationmark")
                } description: {
                    Text(msg)
                } actions: {
                    Button {
                        Task {
                            await model.retry()
                        }
                    } label: {
                        Text("Retry")
                    }

                }
            }
        }
        .task {
            await model.load()
        }
        .navigationTitle("NSScreencast")
    }
}

private struct EpisodeList: View {
    let episodes: [API.V2.Episode]

    var body: some View {
        List(episodes) {
            EpisodeRow(episode: $0)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

private struct EpisodeRow: View {
    let episode: API.V2.Episode

    var body: some View {
        HStack {
            thumbnail
            VStack(alignment: .leading) {
                Text(String(episode.episodeNumber))
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.secondary)
                Text(episode.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(episode.publishedAt, format: .dateTime.month().day().year())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var thumbnail: some View {
        AsyncImage(url: episode.artworkUrls.small) { phase in
            switch phase {
            case .empty: ProgressView()
                    .frame(width: 112, height: 68)
            case .failure: Image(systemName: "film")
                    .frame(width: 112, height: 68)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 112, height: 68)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            @unknown default: EmptyView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        EpisodeListView()
    }
}

#Preview("Episode Row", traits: .sizeThatFitsLayout) {
    EpisodeRow(episode: .sample)
        .frame(height: 80)
}
