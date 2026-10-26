import SwiftUI
import Playgrounds
import APIClient
import SQLiteData
import Database

@main struct MyApp: App {
    init() {
        prepareDependencies {
            $0.defaultDatabase = try! appDatabase()
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    let client = APIClient()
                    let page = try! await client.fetchEpisodePage(
                        after: nil,
                        limit: nil
                    )
                    print(page)
                }
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

#Preview {
    ContentView()
}

#Playground {
    Task {
        let client = APIClient()
        let page = try! await client.fetchEpisodePage(
            after: nil,
            limit: nil
        )
        print(page)
    }
}
