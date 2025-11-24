import Foundation
import Contentful

class ContentfulService: ObservableObject {
    static let shared = ContentfulService()
    
    private var client: Client
    
    init() {
        let spaceId = ProcessInfo.processInfo.environment["CONTENTFUL_SPACE_ID"] ?? ""
        let accessToken = ProcessInfo.processInfo.environment["CONTENTFUL_ACCESS_TOKEN"] ?? ""
        let previewToken = ProcessInfo.processInfo.environment["CONTENTFUL_PREVIEW_ACCESS_TOKEN"] ?? ""
        let usePreview = ProcessInfo.processInfo.environment["CONTENTFUL_USE_PREVIEW"] == "true"
        
        let credentials = ContentfulCredentials(
            spaceId: spaceId,
            accessToken: usePreview ? previewToken : accessToken
        )
        
        self.client = Client(credentials: credentials)
    }
    
    func fetchPage(slug: String, locale: String = "en-US") async throws -> Page? {
        let query = QueryOn<Page>.where(field: .slug, .equals(slug))
            .localizeResults(withLocaleCode: locale)
            .include(10)
        
        let response = try await client.fetchArray(of: Page.self, matching: query)
        return response.items.first
    }
    
    func fetchNavigation(locale: String = "en-US") async throws -> Navigation? {
        let query = QueryOn<Navigation>()
            .localizeResults(withLocaleCode: locale)
            .include(10)
            .limit(to: 1)
        
        let response = try await client.fetchArray(of: Navigation.self, matching: query)
        return response.items.first
    }
    
    func fetchFooter(locale: String = "en-US") async throws -> Footer? {
        let query = QueryOn<Footer>()
            .localizeResults(withLocaleCode: locale)
            .include(10)
            .limit(to: 1)
        
        let response = try await client.fetchArray(of: Footer.self, matching: query)
        return response.items.first
    }
    
    func fetchHomePage(locale: String = "en-US") async throws -> Page? {
        return try await fetchPage(slug: "home", locale: locale)
    }
}

struct ContentfulCredentials {
    let spaceId: String
    let accessToken: String
}

