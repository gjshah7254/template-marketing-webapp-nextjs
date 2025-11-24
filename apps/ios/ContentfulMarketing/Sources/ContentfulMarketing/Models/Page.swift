import Foundation
import Contentful

final class Page: EntryDecodable, Resource, FieldKeysQueryable {
    static let contentTypeId: String = "page"
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let slug: String?
    let pageName: String?
    let seoFields: SEOFields?
    let topSection: [EntryDecodable]?
    let pageContent: EntryDecodable?
    let extraSection: [EntryDecodable]?
    
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
        topSection = try fields.decodeIfPresent([Link].self, forKey: .topSection)?.compactMap { $0 }
        pageContent = try fields.decodeIfPresent(Link.self, forKey: .pageContent)
        extraSection = try fields.decodeIfPresent([Link].self, forKey: .extraSection)?.compactMap { $0 }
    }
}

struct SEOFields: Decodable {
    let pageTitle: String?
    let pageDescription: String?
    let keywords: [String]?
    let image: Asset?
}

