import Foundation
import Contentful

final class Navigation: EntryDecodable, FieldKeysQueryable {
    static let contentTypeId: String = "navigation"
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    var menuItems: [MenuGroup]?
    
    enum FieldKeys: String, CodingKey {
        case menuItems
    }
    
    required init(from decoder: Decoder) throws {
        let fields = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        let sys = try decoder.sys()
        
        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        var menuItemsArray: [MenuGroup] = []
        try fields.resolveLinksArray(forKey: .menuItems, decoder: decoder) { item in
            if let menuGroup = item as? MenuGroup {
                menuItemsArray.append(menuGroup)
            }
        }
        menuItems = menuItemsArray.isEmpty ? nil : menuItemsArray
    }
}

final class MenuGroup: EntryDecodable, FieldKeysQueryable {
    static let contentTypeId: String = "menuGroup"
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let groupName: String?
    var menuItems: [MenuItem]?
    
    enum FieldKeys: String, CodingKey {
        case groupName, menuItems
    }
    
    required init(from decoder: Decoder) throws {
        let fields = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        let sys = try decoder.sys()
        
        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        groupName = try fields.decodeIfPresent(String.self, forKey: .groupName)
        
        var menuItemsArray: [MenuItem] = []
        try fields.resolveLinksArray(forKey: .menuItems, decoder: decoder) { item in
            if let menuItem = item as? MenuItem {
                menuItemsArray.append(menuItem)
            }
        }
        menuItems = menuItemsArray.isEmpty ? nil : menuItemsArray
    }
}

final class MenuItem: EntryDecodable, FieldKeysQueryable {
    static let contentTypeId: String = "menuItem"
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let label: String?
    let path: String?
    let externalLink: String?
    
    enum FieldKeys: String, CodingKey {
        case label, path, externalLink
    }
    
    required init(from decoder: Decoder) throws {
        let fields = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        let sys = try decoder.sys()
        
        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        label = try fields.decodeIfPresent(String.self, forKey: .label)
        path = try fields.decodeIfPresent(String.self, forKey: .path)
        externalLink = try fields.decodeIfPresent(String.self, forKey: .externalLink)
    }
}

