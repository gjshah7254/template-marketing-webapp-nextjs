import SwiftUI
import Kingfisher

@main
struct ContentfulMarketingApp: App {
    init() {
        // Configure Kingfisher to use a custom URLSession with proper User-Agent
        // This prevents CFNetwork crashes when environment variables are numbers
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "User-Agent": "ContentfulMarketing-iOS/1.0"
        ]
        let session = URLSession(configuration: configuration)
        
        // Set the default image downloader to use our custom session
        ImageDownloader.default.sessionConfiguration = configuration
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

