import Foundation
// import Contentful // Removed - using GraphQL instead

final class Footer: EntryDecodable, FieldKeysQueryable {
    static let contentTypeId: String = "footer"
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let logo: Asset?
    var menuItems: [MenuGroup]?
    var socialLinks: [SocialLink]?
    let copyrightText: String?
    
    enum FieldKeys: String, CodingKey {
        case logo, menuItems, socialLinks, copyrightText
    }
    
    required init(from decoder: Decoder) throws {
        let fields = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        let sys = try decoder.sys()
        
        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        logo = try fields.decodeIfPresent(Asset.self, forKey: .logo)
        copyrightText = try fields.decodeIfPresent(String.self, forKey: .copyrightText)
        
        var menuItemsArray: [MenuGroup] = []
        try fields.resolveLinksArray(forKey: .menuItems, decoder: decoder) { item in
            if let menuGroup = item as? MenuGroup {
                menuItemsArray.append(menuGroup)
    }
}
        menuItems = menuItemsArray.isEmpty ? nil : menuItemsArray
        
        var socialLinksArray: [SocialLink] = []
        try fields.resolveLinksArray(forKey: .socialLinks, decoder: decoder) { item in
            if let socialLink = item as? SocialLink {
                socialLinksArray.append(socialLink)
            }
        }
        socialLinks = socialLinksArray.isEmpty ? nil : socialLinksArray
    }
}

final class SocialLink: EntryDecodable, FieldKeysQueryable {
    static let contentTypeId: String = "socialLink"
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let label: String?
    let url: String?
    let icon: Asset?
    
    enum FieldKeys: String, CodingKey {
        case label, url, icon
    }
    
    required init(from decoder: Decoder) throws {
        let fields = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        let sys = try decoder.sys()
        
        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        label = try fields.decodeIfPresent(String.self, forKey: .label)
        url = try fields.decodeIfPresent(String.self, forKey: .url)
        icon = try fields.decodeIfPresent(Asset.self, forKey: .icon)
    }
}

