import Foundation

// MARK: - GraphQL Request/Response Models

struct GraphQLRequest: Codable {
    let query: String
    let variables: [String: String]?
}

struct GraphQLResponse<T: Codable>: Codable {
    let data: T?
    let errors: [GraphQLError]?
}

struct GraphQLData: Codable {
    let pageCollection: PageCollection?
    let navigationCollection: NavigationCollection?
    let footerCollection: FooterCollection?
}

struct PageCollection: Codable {
    let items: [GraphQLPage]
}

struct NavigationCollection: Codable {
    let items: [GraphQLNavigation]
}

struct FooterCollection: Codable {
    let items: [GraphQLFooter]
}

struct GraphQLError: Codable {
    let message: String
}

// MARK: - GraphQL Service

class GraphQLService {
    static let shared = GraphQLService()
    
    private let baseURL = "https://graphql.contentful.com/content/v1/spaces"
    private var spaceId: String
    private var accessToken: String
    private let environment: String
    
    init() {
        // Get from environment variables or use defaults
        self.spaceId = ProcessInfo.processInfo.environment["CONTENTFUL_SPACE_ID"] ?? "developer_bookshelf"
        self.accessToken = ProcessInfo.processInfo.environment["CONTENTFUL_DELIVERY_ACCESS_TOKEN"] ?? "0b7f6x59a0"
        self.environment = ProcessInfo.processInfo.environment["CONTENTFUL_ENVIRONMENT"] ?? "master"
    }
    
    private func performQuery<T: Codable>(query: String, variables: [String: String] = [:]) async throws -> T {
        let urlString = "\(baseURL)/\(spaceId)/environments/\(environment)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "GraphQLService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let graphQLRequest = GraphQLRequest(query: query, variables: variables.isEmpty ? nil : variables)
        request.httpBody = try JSONEncoder().encode(graphQLRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "GraphQLService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "GraphQLService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode): \(errorMessage)"])
        }
        
        let decoder = JSONDecoder()
        let graphQLResponse = try decoder.decode(GraphQLResponse<T>.self, from: data)
        
        if let errors = graphQLResponse.errors, !errors.isEmpty {
            let errorMessages = errors.map { $0.message }.joined(separator: ", ")
            throw NSError(domain: "GraphQLService", code: -1, userInfo: [NSLocalizedDescriptionKey: "GraphQL errors: \(errorMessages)"])
        }
        
        guard let result = graphQLResponse.data else {
            throw NSError(domain: "GraphQLService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data in response"])
        }
        
        return result
    }
    
    func fetchPage(slug: String, locale: String = "en-US") async throws -> GraphQLPage? {
        let query = """
            query GetPage($slug: String!, $locale: String!) {
              pageCollection(where: { slug: $slug }, locale: $locale, limit: 1) {
                items {
                  sys { id }
                  slug
                  pageName
                  topSectionCollection {
                    items {
                      __typename
                      ... on Entry {
                        sys { id }
                      }
                      ... on ComponentHeroBanner {
                        headline
                        bodyText { json }
                        ctaText
                        image { url }
                        imageStyle
                        colorPalette
                      }
                      ... on ComponentCta {
                        headline
                        subline { json }
                        ctaText
                        colorPalette
                      }
                      ... on ComponentTextBlock {
                        headline
                        subline
                        body { json }
                        colorPalette
                      }
                      ... on ComponentInfoBlock {
                        headline
                        subline
                        block1Image { url }
                        block1Body { json }
                        block2Image { url }
                        block2Body { json }
                        block3Image { url }
                        block3Body { json }
                        colorPalette
                      }
                      ... on ComponentDuplex {
                        headline
                        bodyText { json }
                        image { url }
                        imageStyle
                        colorPalette
                      }
                      ... on ComponentQuote {
                        quote { json }
                        image { url }
                        imagePosition
                        colorPalette
                      }
                    }
                  }
                  pageContent {
                    __typename
                    ... on Entry {
                      sys { id }
                    }
                  }
                  extraSectionCollection {
                    items {
                      __typename
                      ... on Entry {
                        sys { id }
                      }
                    }
                  }
                }
              }
            }
        """
        
        let data: GraphQLData = try await performQuery(query: query, variables: ["slug": slug, "locale": locale])
        return data.pageCollection?.items.first
    }
    
    func fetchNavigation(locale: String = "en-US") async throws -> GraphQLNavigation? {
        let query = """
            query GetNavigation($locale: String!) {
              navigationCollection(locale: $locale, limit: 1) {
                items {
                  sys { id }
                  menuItemsCollection {
                    items {
                      sys { id }
                      groupName
                      menuItemsCollection {
                        items {
                          sys { id }
                          label
                          path
                          externalLink
                        }
                      }
                    }
                  }
                }
              }
            }
        """
        
        let data: GraphQLData = try await performQuery(query: query, variables: ["locale": locale])
        return data.navigationCollection?.items.first
    }
    
    func fetchFooter(locale: String = "en-US") async throws -> GraphQLFooter? {
        let query = """
            query GetFooter($locale: String!) {
              footerCollection(locale: $locale, limit: 1) {
                items {
                  sys { id }
                  logo { url }
                  menuItemsCollection {
                    items {
                      sys { id }
                      groupName
                      menuItemsCollection {
                        items {
                          sys { id }
                          label
                          path
                          externalLink
                        }
                      }
                    }
                  }
                  copyrightText
                }
              }
            }
        """
        
        let data: GraphQLData = try await performQuery(query: query, variables: ["locale": locale])
        return data.footerCollection?.items.first
    }
}

