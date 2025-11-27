import Foundation

// Import EnvLoader for .env file support
// Note: EnvLoader is in the Utils directory

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
    let navigationMenuCollection: GraphQLNavigationMenuCollection?
    let footerMenuCollection: GraphQLFooterMenuCollection?
}

struct PageCollection: Codable {
    let items: [GraphQLPage]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Safely decode items array, defaulting to empty array if decoding fails
        // Handle case where items might be a dictionary or other type
        do {
            items = try container.decode([GraphQLPage].self, forKey: .items)
        } catch {
            items = []
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}

// NavigationCollection removed - using GraphQLNavigationMenuCollection instead

struct FooterCollection: Codable {
    let items: [GraphQLFooter]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Safely decode items array, defaulting to empty array if decoding fails
        // Handle case where items might be a dictionary or other type
        do {
            items = try container.decode([GraphQLFooter].self, forKey: .items)
        } catch {
            items = []
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}

struct GraphQLError: Codable {
    let message: String
}

// MARK: - GraphQL Service

class GraphQLService {
    static let shared = GraphQLService()
    
    private let baseURL = "https://graphql.contentful.com/content/v1/spaces"
    private let spaceId: String
    private let accessToken: String
    private let environment: String
    
    // Create a custom URLSession to avoid CFNetwork User-Agent issues
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "User-Agent": "ContentfulMarketing-iOS/1.0"
        ]
        return URLSession(configuration: configuration)
    }()
    
    private init() {
        // Load from .env file first, then fall back to system environment variables
        let envLoader = EnvLoader.shared
        
        // Get values with explicit string conversion to prevent type mismatch crashes
        func getStringEnv(_ key: String, defaultValue: String) -> String {
            let value = envLoader.get(key, default: defaultValue)
            // Ensure it's a string, not a number
            // Use explicit string conversion and trimming
            let stringValue = String(describing: value).trimmingCharacters(in: .whitespacesAndNewlines)
            return stringValue.isEmpty ? defaultValue : stringValue
        }
        
        // Store as immutable strings to prevent any type issues
        self.spaceId = getStringEnv("CONTENTFUL_SPACE_ID", defaultValue: "developer_bookshelf")
        self.accessToken = getStringEnv("CONTENTFUL_DELIVERY_ACCESS_TOKEN", defaultValue: "0b7f6x59a0")
        // Try both ENVIRONMENT_NAME (Android/Next.js format) and CONTENTFUL_ENVIRONMENT
        let envName = getStringEnv("ENVIRONMENT_NAME", defaultValue: "")
        self.environment = envName.isEmpty ? getStringEnv("CONTENTFUL_ENVIRONMENT", defaultValue: "master") : envName
        
    }
    
    private func performQuery<T: Codable>(query: String, variables: [String: String] = [:]) async throws -> T {
        // Ensure all URL components are strings and properly formatted
        let safeSpaceId = String(describing: spaceId).trimmingCharacters(in: .whitespacesAndNewlines)
        let safeEnvironment = String(describing: environment).trimmingCharacters(in: .whitespacesAndNewlines)
        let safeAccessToken = String(describing: accessToken).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let urlString = "\(baseURL)/\(safeSpaceId)/environments/\(safeEnvironment)"
        
        guard let url = URL(string: urlString) else {
            let errorMsg = "Invalid URL: \(urlString) (spaceId: \(safeSpaceId), environment: \(safeEnvironment))"
            throw NSError(domain: "GraphQLService", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMsg])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Ensure authorization header is properly formatted as string
        let authHeader = "Bearer \(safeAccessToken)"
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set User-Agent explicitly to avoid CFNetwork issues
        request.setValue("ContentfulMarketing-iOS/1.0", forHTTPHeaderField: "User-Agent")
        
        // Ensure all variables are strings
        let safeVariables: [String: String] = variables.mapValues { String(describing: $0) }
        let graphQLRequest = GraphQLRequest(query: query, variables: safeVariables.isEmpty ? nil : safeVariables)
        
        do {
            request.httpBody = try JSONEncoder().encode(graphQLRequest)
        } catch {
            throw NSError(domain: "GraphQLService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode request: \(error.localizedDescription)"])
        }
        
        // Use custom URLSession instead of shared to avoid CFNetwork User-Agent initialization issues
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "GraphQLService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "GraphQLService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode): \(errorMessage)"])
        }
        
        let decoder = JSONDecoder()
        
        do {
            let graphQLResponse = try decoder.decode(GraphQLResponse<T>.self, from: data)
            
            if let errors = graphQLResponse.errors, !errors.isEmpty {
                let errorMessages = errors.map { $0.message }.joined(separator: "\n")
                
                // Log the full error for debugging
                print("GraphQL Error Details:")
                print("Space ID: \(spaceId)")
                print("Environment: \(environment)")
                print("Error Messages: \(errorMessages)")
                
                if errorMessages.contains("Cannot query field") || errorMessages.contains("Unknown type") {
                    let helpfulMessage = """
                    GraphQL Schema Mismatch Error:
                    
                    \(errorMessages)
                    
                    This usually means you're using the wrong Contentful space.
                    The app is currently configured with:
                    - Space ID: \(spaceId)
                    - Environment: \(environment)
                    
                    Please configure the iOS app with the same Contentful space ID and access token
                    that your Next.js app uses. See ENV_SETUP.md for instructions.
                    """
                    throw NSError(domain: "GraphQLService", code: -1, userInfo: [NSLocalizedDescriptionKey: helpfulMessage])
                }
                
                throw NSError(domain: "GraphQLService", code: -1, userInfo: [NSLocalizedDescriptionKey: "GraphQL errors: \(errorMessages)"])
            }
            
            guard let result = graphQLResponse.data else {
                throw NSError(domain: "GraphQLService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data in response"])
            }
            
            return result
        } catch let decodingError as DecodingError {
            // Better error handling for decoding issues
            let errorDescription: String
            switch decodingError {
            case .typeMismatch(let type, let context):
                errorDescription = "Type mismatch for \(type) at \(context.codingPath.map { $0.stringValue }.joined(separator: ".")): \(context.debugDescription)"
            case .valueNotFound(let type, let context):
                errorDescription = "Value not found for \(type) at \(context.codingPath.map { $0.stringValue }.joined(separator: ".")): \(context.debugDescription)"
            case .keyNotFound(let key, let context):
                errorDescription = "Key not found: \(key.stringValue) at \(context.codingPath.map { $0.stringValue }.joined(separator: "."))"
            case .dataCorrupted(let context):
                errorDescription = "Data corrupted at \(context.codingPath.map { $0.stringValue }.joined(separator: ".")): \(context.debugDescription)"
            @unknown default:
                errorDescription = "Unknown decoding error: \(decodingError.localizedDescription)"
            }
            throw NSError(domain: "GraphQLService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(errorDescription)"])
        }
    }
    
    func fetchPage(slug: String, locale: String = "en-US") async throws -> GraphQLPage? {
        do {
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
                        subline: subline { json }
                        ctaText
                        colorPalette
                      }
                      ... on ComponentTextBlock {
                        headline
                        sublineText: subline
                        body { json }
                        colorPalette
                      }
                      ... on ComponentInfoBlock {
                        headline
                        sublineText: subline
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
                        containerLayout
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
                        subline: subline { json }
                        ctaText
                        colorPalette
                      }
                      ... on ComponentTextBlock {
                        headline
                        sublineText: subline
                        body { json }
                        colorPalette
                      }
                      ... on ComponentInfoBlock {
                        headline
                        sublineText: subline
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
                        containerLayout
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
                }
              }
            }
        """
        
            let data: GraphQLData = try await performQuery(query: query, variables: ["slug": slug, "locale": locale])
            
            if let pageCollection = data.pageCollection, !pageCollection.items.isEmpty {
                return pageCollection.items.first
            }
            return nil
        } catch {
            throw error
        }
    }
    
    func fetchNavigation(locale: String = "en-US") async throws -> GraphQLNavigationMenu? {
        let query = """
            query GetNavigation($locale: String!) {
              navigationMenuCollection(locale: $locale, limit: 1) {
                items {
                  menuItemsCollection {
                    items {
                      __typename
                      sys { id }
                      groupName
                      groupLink {
                        ... on Page {
                          __typename
                          slug
                          sys { id }
                          pageName
                        }
                      }
                      featuredPagesCollection {
                        items {
                          ... on Page {
                            __typename
                            slug
                          sys { id }
                            pageName
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
        """
        
        let data: GraphQLData = try await performQuery(query: query, variables: ["locale": locale])
        guard let navigationMenuCollection = data.navigationMenuCollection,
              !navigationMenuCollection.items.isEmpty else {
            return nil
        }
        return navigationMenuCollection.items.first
    }
    
    func fetchFooter(locale: String = "en-US") async throws -> GraphQLFooterMenu? {
        let query = """
            query GetFooter($locale: String!) {
              footerMenuCollection(locale: $locale, limit: 1) {
                items {
                  __typename
                  sys { id }
                  menuItemsCollection {
                    items {
                      __typename
                      sys { id }
                      groupName
                      featuredPagesCollection {
                        items {
                          ... on Page {
                            __typename
                            slug
                            sys { id }
                            pageName
                          }
                        }
                      }
                    }
                  }
                  legalLinks {
                    featuredPagesCollection {
                      items {
                        ... on Page {
                          __typename
                          slug
                          sys { id }
                          pageName
                        }
                      }
                    }
                  }
                  twitterLink
                  facebookLink
                  linkedinLink
                  instagramLink
                }
              }
            }
        """
        
        let data: GraphQLData = try await performQuery(query: query, variables: ["locale": locale])
        guard let footerMenuCollection = data.footerMenuCollection,
              !footerMenuCollection.items.isEmpty else {
            return nil
        }
        return footerMenuCollection.items.first
    }
}


