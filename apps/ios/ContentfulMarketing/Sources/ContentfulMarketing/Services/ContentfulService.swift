import Foundation
import Contentful

class ContentfulService: ObservableObject {
    static let shared = ContentfulService()
    
    private var client: Client
    
    init() {
        // Try to get from environment variables, fallback to empty strings
        let spaceId = ProcessInfo.processInfo.environment["CONTENTFUL_SPACE_ID"] ?? ""
        let accessToken = ProcessInfo.processInfo.environment["CONTENTFUL_ACCESS_TOKEN"] ?? ""
        let previewToken = ProcessInfo.processInfo.environment["CONTENTFUL_PREVIEW_ACCESS_TOKEN"] ?? ""
        let usePreview = ProcessInfo.processInfo.environment["CONTENTFUL_USE_PREVIEW"] == "true"
        
        let token = usePreview ? previewToken : accessToken
        
        // Use default demo credentials if not provided (for testing)
        let finalSpaceId = spaceId.isEmpty ? "developer_bookshelf" : spaceId
        let finalToken = token.isEmpty ? "0b7f6x59a0" : token
        
        self.client = Client(
            spaceId: finalSpaceId,
            accessToken: finalToken,
            contentTypeClasses: [
                Page.self,
                Navigation.self,
                Footer.self,
                MenuGroup.self,
                MenuItem.self,
                SocialLink.self,
                HeroBanner.self,
                CTA.self,
                TextBlock.self,
                InfoBlock.self,
                Duplex.self,
                Quote.self
            ]
        )
    }
    
    func fetchPage(slug: String, locale: String = "en-US") async throws -> Page? {
        return try await withCheckedThrowingContinuation { continuation in
            // Try a simpler query first without include to avoid complex decoding
            // This reduces the chance of SDK crashes during link resolution
            let query = QueryOn<Page>.where(field: .slug, .equals(slug))
                .localizeResults(withLocaleCode: locale)
                .include(0) // Start with 0 includes to avoid complex link resolution
            
            _ = client.fetchArray(of: Page.self, matching: query) { result in
                switch result {
                case .success(let response):
                    // Safely access items array
                    if !response.items.isEmpty {
                        continuation.resume(returning: response.items.first)
                    } else {
                        continuation.resume(returning: nil)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchNavigation(locale: String = "en-US") async throws -> Navigation? {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let query = QueryOn<Navigation>()
                    .localizeResults(withLocaleCode: locale)
                    .include(10)
                    .limit(to: 1)
                
                _ = client.fetchArray(of: Navigation.self, matching: query) { result in
                    switch result {
                    case .success(let response):
                        if !response.items.isEmpty {
                            continuation.resume(returning: response.items.first)
                        } else {
                            continuation.resume(returning: nil)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func fetchFooter(locale: String = "en-US") async throws -> Footer? {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let query = QueryOn<Footer>()
                    .localizeResults(withLocaleCode: locale)
                    .include(10)
                    .limit(to: 1)
                
                _ = client.fetchArray(of: Footer.self, matching: query) { result in
                    switch result {
                    case .success(let response):
                        if !response.items.isEmpty {
                            continuation.resume(returning: response.items.first)
                        } else {
                            continuation.resume(returning: nil)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func fetchHomePage(locale: String = "en-US") async throws -> Page? {
        return try await fetchPage(slug: "home", locale: locale)
    }
}

