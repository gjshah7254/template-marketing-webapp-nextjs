import Foundation
import Contentful

final class Page: EntryDecodable, FieldKeysQueryable {
    static let contentTypeId: String = "page"
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let slug: String?
    let pageName: String?
    let seoFields: SEOFields?
    var topSection: [EntryDecodable]?
    var pageContent: EntryDecodable?
    var extraSection: [EntryDecodable]?
    
    enum FieldKeys: String, CodingKey {
        case slug, pageName, seoFields, topSection, pageContent, extraSection
    }
    
    required init(from decoder: Decoder) throws {
        let fields = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        let sys = try decoder.sys()
        
        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        slug = try fields.decodeIfPresent(String.self, forKey: .slug)
        pageName = try fields.decodeIfPresent(String.self, forKey: .pageName)
        seoFields = try fields.decodeIfPresent(SEOFields.self, forKey: .seoFields)
        
        var topSectionItems: [EntryDecodable] = []
        try fields.resolveLinksArray(forKey: .topSection, decoder: decoder) { item in
            if let entryDecodable = item as? EntryDecodable {
                topSectionItems.append(entryDecodable)
            }
        }
        topSection = topSectionItems.isEmpty ? nil : topSectionItems
        
        try fields.resolveLink(forKey: .pageContent, decoder: decoder) { [weak self] item in
            self?.pageContent = item as? EntryDecodable
        }
        
        var extraSectionItems: [EntryDecodable] = []
        try fields.resolveLinksArray(forKey: .extraSection, decoder: decoder) { item in
            if let entryDecodable = item as? EntryDecodable {
                extraSectionItems.append(entryDecodable)
            }
        }
        extraSection = extraSectionItems.isEmpty ? nil : extraSectionItems
    }
}

struct SEOFields: Decodable {
    let pageTitle: String?
    let pageDescription: String?
    let keywords: [String]?
    let image: Asset?
}

