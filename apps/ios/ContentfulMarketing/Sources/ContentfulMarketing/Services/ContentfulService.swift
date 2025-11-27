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
    
    func fetchNavigation(locale: String = "en-US") async throws -> NavigationData? {
        guard let graphQLNav = try await graphQLService.fetchNavigation(locale: locale) else {
            return nil
        }
        return NavigationData.fromGraphQL(graphQLNav)
    }
    
    func fetchFooter(locale: String = "en-US") async throws -> FooterData? {
        guard let graphQLFooter = try await graphQLService.fetchFooter(locale: locale) else {
            return nil
        }
        return FooterData.fromGraphQL(graphQLFooter)
    }
}

