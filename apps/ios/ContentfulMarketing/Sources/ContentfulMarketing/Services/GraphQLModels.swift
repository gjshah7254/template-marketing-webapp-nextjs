import Foundation

// MARK: - GraphQL Response Models

struct GraphQLPage: Codable {
    let sys: GraphQLSys
    let slug: String?
    let pageName: String?
    let topSectionCollection: GraphQLCollection<GraphQLComponent>?
    let pageContent: GraphQLComponent?
    let extraSectionCollection: GraphQLCollection<GraphQLComponent>?
}

struct GraphQLNavigationMenu: Codable {
    let menuItemsCollection: GraphQLCollection<GraphQLMenuGroup>?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        menuItemsCollection = try? container.decodeIfPresent(GraphQLCollection<GraphQLMenuGroup>.self, forKey: .menuItemsCollection)
    }
    
    enum CodingKeys: String, CodingKey {
        case menuItemsCollection
    }
}

struct GraphQLNavigationMenuCollection: Codable {
    let items: [GraphQLNavigationMenu]
}

struct GraphQLFooterMenu: Codable {
    let sys: GraphQLSys
    let menuItemsCollection: GraphQLCollection<GraphQLFooterMenuGroup>?
    let legalLinks: GraphQLLegalLinks?
    let twitterLink: String?
    let facebookLink: String?
    let linkedinLink: String?
    let instagramLink: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sys = try container.decode(GraphQLSys.self, forKey: .sys)
        menuItemsCollection = try? container.decodeIfPresent(GraphQLCollection<GraphQLFooterMenuGroup>.self, forKey: .menuItemsCollection)
        legalLinks = try? container.decodeIfPresent(GraphQLLegalLinks.self, forKey: .legalLinks)
        twitterLink = try? container.decodeIfPresent(String.self, forKey: .twitterLink)
        facebookLink = try? container.decodeIfPresent(String.self, forKey: .facebookLink)
        linkedinLink = try? container.decodeIfPresent(String.self, forKey: .linkedinLink)
        instagramLink = try? container.decodeIfPresent(String.self, forKey: .instagramLink)
    }
    
    enum CodingKeys: String, CodingKey {
        case sys
        case menuItemsCollection
        case legalLinks
        case twitterLink
        case facebookLink
        case linkedinLink
        case instagramLink
    }
}

struct GraphQLFooterMenuCollection: Codable {
    let items: [GraphQLFooterMenu]
}

struct GraphQLFooterMenuGroup: Codable {
    let sys: GraphQLSys
    let groupName: String?
    let featuredPagesCollection: GraphQLCollection<GraphQLPageLink>?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sys = try container.decode(GraphQLSys.self, forKey: .sys)
        groupName = try? container.decodeIfPresent(String.self, forKey: .groupName)
        featuredPagesCollection = try? container.decodeIfPresent(GraphQLCollection<GraphQLPageLink>.self, forKey: .featuredPagesCollection)
    }
    
    enum CodingKeys: String, CodingKey {
        case sys
        case groupName
        case featuredPagesCollection
    }
}

struct GraphQLLegalLinks: Codable {
    let featuredPagesCollection: GraphQLCollection<GraphQLPageLink>?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        featuredPagesCollection = try? container.decodeIfPresent(GraphQLCollection<GraphQLPageLink>.self, forKey: .featuredPagesCollection)
    }
    
    enum CodingKeys: String, CodingKey {
        case featuredPagesCollection
    }
}

// Keep old GraphQLFooter for backward compatibility if needed
struct GraphQLFooter: Codable {
    let sys: GraphQLSys
    let logo: GraphQLAsset?
    let menuItemsCollection: GraphQLCollection<GraphQLMenuGroup>?
    let copyrightText: String?
}

struct GraphQLSys: Codable {
    let id: String
}

struct GraphQLCollection<T: Codable>: Codable {
    let items: [T]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Safely decode items array, defaulting to empty array if decoding fails
        do {
            items = try container.decode([T].self, forKey: .items)
        } catch {
            items = []
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}

struct GraphQLComponent: Codable {
    let __typename: String?
    let sys: GraphQLSys?
    let headline: String?
    let subline: GraphQLRichText? // For ComponentCta (rich text, aliased)
    let sublineText: String? // For ComponentTextBlock and ComponentInfoBlock (string, aliased)
    let ctaText: String?
    let image: GraphQLAsset?
    let block1Image: GraphQLAsset?
    let block2Image: GraphQLAsset?
    let block3Image: GraphQLAsset?
    let colorPalette: String?
    let bodyText: GraphQLRichText?
    let body: GraphQLRichText? // For ComponentTextBlock
    let imageStyle: Bool? // Boolean in GraphQL schema (image style: fixed/full)
    let containerLayout: Bool? // Boolean in GraphQL schema (layout order: image first/content first)
    let imagePosition: String? // For ComponentQuote
    let quote: GraphQLRichText?
    let block1Body: GraphQLRichText?
    let block2Body: GraphQLRichText?
    let block3Body: GraphQLRichText?
}

struct GraphQLMenuGroup: Codable {
    let sys: GraphQLSys
    let groupName: String?
    let groupLink: GraphQLPageLink?
    let featuredPagesCollection: GraphQLCollection<GraphQLPageLink>?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sys = try container.decode(GraphQLSys.self, forKey: .sys)
        groupName = try? container.decodeIfPresent(String.self, forKey: .groupName)
        
        // Handle groupLink - it might be null or missing
        if container.contains(.groupLink) {
            // Try to decode, but handle gracefully if it fails
            groupLink = try? container.decodeIfPresent(GraphQLPageLink.self, forKey: .groupLink)
        } else {
            groupLink = nil
        }
        
        featuredPagesCollection = try? container.decodeIfPresent(GraphQLCollection<GraphQLPageLink>.self, forKey: .featuredPagesCollection)
    }
    
    enum CodingKeys: String, CodingKey {
        case sys
        case groupName
        case groupLink
        case featuredPagesCollection
    }
}

struct GraphQLPageLink: Codable {
    let __typename: String?
    let sys: GraphQLSys?
    let slug: String?
    let pageName: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        __typename = try? container.decode(String.self, forKey: .__typename)
        sys = try? container.decode(GraphQLSys.self, forKey: .sys)
        slug = try? container.decodeIfPresent(String.self, forKey: .slug)
        pageName = try? container.decodeIfPresent(String.self, forKey: .pageName)
    }
    
    enum CodingKeys: String, CodingKey {
        case __typename
        case sys
        case slug
        case pageName
    }
}

struct GraphQLMenuItem: Codable {
    let sys: GraphQLSys
    let label: String?
    let path: String?
    let externalLink: String?
}

struct GraphQLAsset: Codable {
    let url: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Safely decode url as string, handling cases where it might be a number or other type
        if let urlString = try? container.decode(String.self, forKey: .url), !urlString.isEmpty {
            url = urlString
        } else if container.contains(.url) {
            if let urlNumber = try? container.decode(Int.self, forKey: .url) {
                url = String(urlNumber)
            } else if let urlDouble = try? container.decode(Double.self, forKey: .url) {
                url = String(urlDouble)
            } else if let urlBool = try? container.decode(Bool.self, forKey: .url) {
                url = String(urlBool)
            } else {
                url = nil
            }
        } else {
            url = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}

struct GraphQLRichText: Codable {
    let json: [String: AnyCodable]?
}

// Helper to decode Any type from JSON
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let string = try? container.decode(String.self) {
            value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            value = dictionary.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues { AnyCodable($0) })
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable value cannot be encoded"))
        }
    }
}

