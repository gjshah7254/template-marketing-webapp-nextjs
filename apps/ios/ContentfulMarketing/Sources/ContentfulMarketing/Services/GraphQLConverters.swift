import Foundation

// MARK: - GraphQL to Model Converters

// Simple data models that work with GraphQL
struct PageData {
    let id: String
    let slug: String?
    let pageName: String?
    let topSection: [ComponentData]?
    let pageContent: ComponentData?
    let extraSection: [ComponentData]?
}

enum ComponentData {
    case heroBanner(HeroBannerData)
    case cta(CTAData)
    case textBlock(TextBlockData)
    case infoBlock(InfoBlockData)
    case duplex(DuplexData)
    case quote(QuoteData)
}

struct HeroBannerData {
    let id: String
    let headline: String?
    let subline: String?
    let ctaText: String?
    let imageUrl: String?
    let colorPalette: String?
}

struct CTAData {
    let id: String
    let headline: String?
    let subline: String?
    let ctaText: String?
    let colorPalette: String?
}

struct TextBlockData {
    let id: String
    let headline: String?
    let bodyText: GraphQLRichText?
    let colorPalette: String?
}

struct InfoBlockData {
    let id: String
    let headline: String?
    let subline: String?
    let block1ImageUrl: String?
    let block2ImageUrl: String?
    let block3ImageUrl: String?
    let block1Body: GraphQLRichText?
    let block2Body: GraphQLRichText?
    let block3Body: GraphQLRichText?
    let colorPalette: String?
}

struct DuplexData {
    let id: String
    let headline: String?
    let bodyText: GraphQLRichText?
    let imageUrl: String?
    let imageStyle: String?
    let colorPalette: String?
}

struct QuoteData {
    let id: String
    let quote: GraphQLRichText?
    let imageUrl: String?
    let imagePosition: String?
    let colorPalette: String?
}

// Converters from GraphQL to data models
extension PageData {
    static func fromGraphQL(_ graphQLPage: GraphQLPage) -> PageData {
        return PageData(
            id: graphQLPage.sys.id,
            slug: graphQLPage.slug,
            pageName: graphQLPage.pageName,
            topSection: graphQLPage.topSectionCollection?.items.compactMap { ComponentData.fromGraphQL($0) },
            pageContent: graphQLPage.pageContent.flatMap { ComponentData.fromGraphQL($0) },
            extraSection: graphQLPage.extraSectionCollection?.items.compactMap { ComponentData.fromGraphQL($0) }
        )
    }
}

extension ComponentData {
    static func fromGraphQL(_ component: GraphQLComponent) -> ComponentData? {
        guard let typename = component.__typename, let sys = component.sys else {
            return nil
        }
        
        switch typename {
        case "ComponentHeroBanner":
            return .heroBanner(HeroBannerData(
                id: sys.id,
                headline: component.headline,
                subline: component.subline,
                ctaText: component.ctaText,
                imageUrl: component.image?.url,
                colorPalette: component.colorPalette
            ))
        case "ComponentCta":
            return .cta(CTAData(
                id: sys.id,
                headline: component.headline,
                subline: component.subline,
                ctaText: component.ctaText,
                colorPalette: component.colorPalette
            ))
        case "ComponentTextBlock":
            return .textBlock(TextBlockData(
                id: sys.id,
                headline: component.headline,
                bodyText: component.body ?? component.bodyText,
                colorPalette: component.colorPalette
            ))
        case "ComponentInfoBlock":
            return .infoBlock(InfoBlockData(
                id: sys.id,
                headline: component.headline,
                subline: component.subline,
                block1ImageUrl: component.block1Image?.url,
                block2ImageUrl: component.block2Image?.url,
                block3ImageUrl: component.block3Image?.url,
                block1Body: component.block1Body,
                block2Body: component.block2Body,
                block3Body: component.block3Body,
                colorPalette: component.colorPalette
            ))
        case "ComponentDuplex":
            return .duplex(DuplexData(
                id: sys.id,
                headline: component.headline,
                bodyText: component.bodyText,
                imageUrl: component.image?.url,
                imageStyle: component.imageStyle,
                colorPalette: component.colorPalette
            ))
        case "ComponentQuote":
            return .quote(QuoteData(
                id: sys.id,
                quote: component.quote,
                imageUrl: component.image?.url,
                imagePosition: component.imagePosition,
                colorPalette: component.colorPalette
            ))
        default:
            return nil
        }
    }
}

// Navigation and Footer converters - not implemented yet for GraphQL
// These would need to be implemented if Navigation/Footer are needed
