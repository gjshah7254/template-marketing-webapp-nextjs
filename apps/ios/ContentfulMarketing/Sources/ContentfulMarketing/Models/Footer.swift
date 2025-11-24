import Foundation
import Contentful

final class Footer: EntryDecodable, FieldKeysQueryable {
    static let contentTypeId: String = "footer"
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let logo: Asset?
    let menuItems: [MenuGroup]?
    let socialLinks: [SocialLink]?
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
        menuItems = try fields.decodeIfPresent([Link].self, forKey: .menuItems)?.compactMap { $0 as? MenuGroup }
        socialLinks = try fields.decodeIfPresent([Link].self, forKey: .socialLinks)?.compactMap { $0 as? SocialLink }
        copyrightText = try fields.decodeIfPresent(String.self, forKey: .copyrightText)
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

