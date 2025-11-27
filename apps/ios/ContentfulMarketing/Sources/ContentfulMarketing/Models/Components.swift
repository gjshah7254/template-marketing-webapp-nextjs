import Foundation
// import Contentful // Removed - using GraphQL instead

// Hero Banner Component
final class HeroBanner: EntryDecodable, FieldKeysQueryable {
    static let contentTypeId: String = "componentHeroBanner"
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let headline: String?
    let subline: String?
    let ctaText: String?
    let ctaTargetPage: Page?
    let image: Asset?
    let colorPalette: String?
    
    enum FieldKeys: String, CodingKey {
        case headline, subline, ctaText, ctaTargetPage, image, colorPalette
    }
    
    required init(from decoder: Decoder) throws {
        let fields = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        let sys = try decoder.sys()
        
        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        headline = try fields.decodeIfPresent(String.self, forKey: .headline)
        subline = try fields.decodeIfPresent(String.self, forKey: .subline)
        ctaText = try fields.decodeIfPresent(String.self, forKey: .ctaText)
        ctaTargetPage = try fields.decodeIfPresent(Link.self, forKey: .ctaTargetPage) as? Page
        image = try fields.decodeIfPresent(Asset.self, forKey: .image)
        colorPalette = try fields.decodeIfPresent(String.self, forKey: .colorPalette)
    }
}

// CTA Component
final class CTA: EntryDecodable, FieldKeysQueryable {
    static let contentTypeId: String = "componentCta"
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let headline: String?
    let subline: String?
    let ctaText: String?
    let ctaTargetPage: Page?
    let colorPalette: String?
    
    enum FieldKeys: String, CodingKey {
        case headline, subline, ctaText, ctaTargetPage, colorPalette
    }
    
    required init(from decoder: Decoder) throws {
        let fields = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        let sys = try decoder.sys()
        
        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        headline = try fields.decodeIfPresent(String.self, forKey: .headline)
        subline = try fields.decodeIfPresent(String.self, forKey: .subline)
        ctaText = try fields.decodeIfPresent(String.self, forKey: .ctaText)
        ctaTargetPage = try fields.decodeIfPresent(Link.self, forKey: .ctaTargetPage) as? Page
        colorPalette = try fields.decodeIfPresent(String.self, forKey: .colorPalette)
    }
}

// Text Block Component
final class TextBlock: EntryDecodable, FieldKeysQueryable {
    static let contentTypeId: String = "componentTextBlock"
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let headline: String?
    let bodyText: RichTextDocument?
    let colorPalette: String?
    
    enum FieldKeys: String, CodingKey {
        case headline, bodyText, colorPalette
    }
    
    required init(from decoder: Decoder) throws {
        let fields = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        let sys = try decoder.sys()
        
        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        headline = try fields.decodeIfPresent(String.self, forKey: .headline)
        bodyText = try fields.decodeIfPresent(RichTextDocument.self, forKey: .bodyText)
        colorPalette = try fields.decodeIfPresent(String.self, forKey: .colorPalette)
    }
}

// Info Block Component
final class InfoBlock: EntryDecodable, FieldKeysQueryable {
    static let contentTypeId: String = "componentInfoBlock"
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let headline: String?
    let bodyText: RichTextDocument?
    let image: Asset?
    let colorPalette: String?
    
    enum FieldKeys: String, CodingKey {
        case headline, bodyText, image, colorPalette
    }
    
    required init(from decoder: Decoder) throws {
        let fields = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        let sys = try decoder.sys()
        
        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        headline = try fields.decodeIfPresent(String.self, forKey: .headline)
        bodyText = try fields.decodeIfPresent(RichTextDocument.self, forKey: .bodyText)
        image = try fields.decodeIfPresent(Asset.self, forKey: .image)
        colorPalette = try fields.decodeIfPresent(String.self, forKey: .colorPalette)
    }
}

// Duplex Component
final class Duplex: EntryDecodable, FieldKeysQueryable {
    static let contentTypeId: String = "componentDuplex"
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let headline: String?
    let bodyText: RichTextDocument?
    let image: Asset?
    let imagePosition: String?
    let colorPalette: String?
    
    enum FieldKeys: String, CodingKey {
        case headline, bodyText, image, imagePosition, colorPalette
    }
    
    required init(from decoder: Decoder) throws {
        let fields = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        let sys = try decoder.sys()
        
        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        headline = try fields.decodeIfPresent(String.self, forKey: .headline)
        bodyText = try fields.decodeIfPresent(RichTextDocument.self, forKey: .bodyText)
        image = try fields.decodeIfPresent(Asset.self, forKey: .image)
        imagePosition = try fields.decodeIfPresent(String.self, forKey: .imagePosition)
        colorPalette = try fields.decodeIfPresent(String.self, forKey: .colorPalette)
    }
}

// Quote Component
final class Quote: EntryDecodable, FieldKeysQueryable {
    static let contentTypeId: String = "componentQuote"
    
    let id: String
    let localeCode: String?
    let updatedAt: Date?
    let createdAt: Date?
    
    let quoteText: String?
    let authorName: String?
    let authorTitle: String?
    let authorImage: Asset?
    let colorPalette: String?
    
    enum FieldKeys: String, CodingKey {
        case quoteText, authorName, authorTitle, authorImage, colorPalette
    }
    
    required init(from decoder: Decoder) throws {
        let fields = try decoder.contentfulFieldsContainer(keyedBy: FieldKeys.self)
        let sys = try decoder.sys()
        
        id = sys.id
        localeCode = sys.locale
        updatedAt = sys.updatedAt
        createdAt = sys.createdAt
        
        quoteText = try fields.decodeIfPresent(String.self, forKey: .quoteText)
        authorName = try fields.decodeIfPresent(String.self, forKey: .authorName)
        authorTitle = try fields.decodeIfPresent(String.self, forKey: .authorTitle)
        authorImage = try fields.decodeIfPresent(Asset.self, forKey: .authorImage)
        colorPalette = try fields.decodeIfPresent(String.self, forKey: .colorPalette)
    }
}

