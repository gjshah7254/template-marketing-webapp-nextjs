import Foundation

class ContentfulService: ObservableObject {
    static let shared = ContentfulService()
    
    // Lazy initialization to prevent crashes during app startup
    private lazy var graphQLService: GraphQLService = {
        return GraphQLService.shared
    }()
    
    func fetchPage(slug: String, locale: String = "en-US") async throws -> PageData? {
        guard let graphQLPage = try await graphQLService.fetchPage(slug: slug, locale: locale) else {
            return nil
        }
        return PageData.fromGraphQL(graphQLPage)
    }
    
    
    func fetchHomePage(locale: String = "en-US") async throws -> PageData? {
        return try await fetchPage(slug: "home", locale: locale)
    }
}

