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
    let imageStyle: Bool? // Boolean: true = fixed style, false = full style
    let containerLayout: Bool? // Boolean: true = image first, false = content first
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
            // ComponentHeroBanner doesn't have subline in the query, so set it to nil
            // Safely convert image URL to string
            let imageUrlString: String? = {
                guard let url = component.image?.url else { return nil }
                let urlStr = String(describing: url).trimmingCharacters(in: .whitespacesAndNewlines)
                guard !urlStr.isEmpty, urlStr.hasPrefix("http") else { return nil }
                return urlStr
            }()
            
            return .heroBanner(HeroBannerData(
                id: sys.id,
                headline: component.headline,
                subline: nil, // Not fetched in GraphQL query
                ctaText: component.ctaText,
                imageUrl: imageUrlString,
                colorPalette: component.colorPalette
            ))
        case "ComponentCta":
            // ComponentCta uses 'subline' which is rich text (aliased in query as 'subline: subline { json }')
            // The subline field in CTAData is String?, so we'll extract text from rich text JSON
            // This is a simplified extraction - for full rich text rendering, use RichTextRenderer
            var sublineString: String? = nil
            if let richText = component.subline, let jsonDict = richText.json {
                // Try to extract text content from rich text JSON structure
                // This is a basic implementation - you may want to use RichTextRenderer for proper parsing
                // For now, just convert the JSON dictionary to a string representation
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: []),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    sublineString = jsonString
                } else {
                    sublineString = String(describing: jsonDict)
                }
            }
            return .cta(CTAData(
                id: sys.id,
                headline: component.headline,
                subline: sublineString,
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
            // ComponentInfoBlock uses 'sublineText' which is a string (aliased in query)
            // Safely convert image URLs to strings
            let safeUrl: (GraphQLAsset?) -> String? = { asset in
                guard let url = asset?.url else { return nil }
                let urlStr = String(describing: url).trimmingCharacters(in: .whitespacesAndNewlines)
                // Validate it looks like a URL
                guard !urlStr.isEmpty, urlStr.hasPrefix("http") else { return nil }
                return urlStr
            }
            
            return .infoBlock(InfoBlockData(
                id: sys.id,
                headline: component.headline,
                subline: component.sublineText,
                block1ImageUrl: safeUrl(component.block1Image),
                block2ImageUrl: safeUrl(component.block2Image),
                block3ImageUrl: safeUrl(component.block3Image),
                block1Body: component.block1Body,
                block2Body: component.block2Body,
                block3Body: component.block3Body,
                colorPalette: component.colorPalette
            ))
        case "ComponentDuplex":
            // Safely convert image URL to string
            let imageUrlString: String? = {
                guard let url = component.image?.url else { return nil }
                let urlStr = String(describing: url).trimmingCharacters(in: .whitespacesAndNewlines)
                // Validate it looks like a URL
                guard !urlStr.isEmpty, urlStr.hasPrefix("http") else { return nil }
                return urlStr
            }()
            
            return .duplex(DuplexData(
                id: sys.id,
                headline: component.headline,
                bodyText: component.bodyText,
                imageUrl: imageUrlString,
                imageStyle: component.imageStyle,
                containerLayout: component.containerLayout,
                colorPalette: component.colorPalette
            ))
        case "ComponentQuote":
            // Safely convert image URL to string
            let imageUrlString: String? = {
                guard let url = component.image?.url else { return nil }
                let urlStr = String(describing: url).trimmingCharacters(in: .whitespacesAndNewlines)
                // Validate it looks like a URL
                guard !urlStr.isEmpty, urlStr.hasPrefix("http") else { return nil }
                return urlStr
            }()
            
            return .quote(QuoteData(
                id: sys.id,
                quote: component.quote,
                imageUrl: imageUrlString,
                imagePosition: component.imagePosition,
                colorPalette: component.colorPalette
            ))
        default:
            return nil
        }
    }
}

// Navigation data models
struct NavigationData {
    let id: String
    let menuItems: [MenuGroupData]?
}

struct MenuGroupData: Identifiable {
    let id: String
    let groupName: String?
    let link: MenuItemData? // If present, the group name is clickable
    let menuItems: [MenuItemData]? // Children/submenu items
}

struct MenuItemData: Identifiable {
    let id: String
    let label: String?
    let path: String?
    let externalLink: String?
}

// Navigation converter
extension NavigationData {
    static func fromGraphQL(_ graphQLNav: GraphQLNavigationMenu) -> NavigationData {
        return NavigationData(
            id: "", // NavigationMenu doesn't have sys.id in the query
            menuItems: graphQLNav.menuItemsCollection?.items.map { MenuGroupData.fromGraphQL($0) }
        )
    }
}

extension MenuGroupData {
    static func fromGraphQL(_ graphQLGroup: GraphQLMenuGroup) -> MenuGroupData {
        // Convert groupLink to MenuItemData if present and valid
        let link: MenuItemData? = graphQLGroup.groupLink.flatMap { pageLink in
            guard let sys = pageLink.sys else { return nil }
            return MenuItemData(
                id: sys.id,
                label: pageLink.pageName,
                path: pageLink.slug,
                externalLink: nil
            )
        }
        
        // Convert featuredPagesCollection to menuItems
        let menuItems: [MenuItemData]? = graphQLGroup.featuredPagesCollection?.items.compactMap { pageLink in
            guard let sys = pageLink.sys else { return nil }
            return MenuItemData(
                id: sys.id,
                label: pageLink.pageName,
                path: pageLink.slug,
                externalLink: nil
            )
        }
        
        return MenuGroupData(
            id: graphQLGroup.sys.id,
            groupName: graphQLGroup.groupName,
            link: link,
            menuItems: menuItems
        )
    }
}

extension MenuItemData {
    static func fromGraphQL(_ graphQLItem: GraphQLMenuItem) -> MenuItemData {
        return MenuItemData(
            id: graphQLItem.sys.id,
            label: graphQLItem.label,
            path: graphQLItem.path,
            externalLink: graphQLItem.externalLink
        )
    }
}

// Footer data models
struct FooterData {
    let id: String
    let menuItems: [FooterMenuGroupData]?
    let legalLinks: [MenuItemData]?
    let twitterLink: String?
    let facebookLink: String?
    let linkedinLink: String?
    let instagramLink: String?
}

struct FooterMenuGroupData: Identifiable {
    let id: String
    let groupName: String?
    let menuItems: [MenuItemData]?
}

// Footer converter
extension FooterData {
    static func fromGraphQL(_ graphQLFooter: GraphQLFooterMenu) -> FooterData {
        return FooterData(
            id: graphQLFooter.sys.id,
            menuItems: graphQLFooter.menuItemsCollection?.items.map { FooterMenuGroupData.fromGraphQL($0) },
            legalLinks: graphQLFooter.legalLinks?.featuredPagesCollection?.items.compactMap { pageLink in
                guard let sys = pageLink.sys else { return nil }
                return MenuItemData(
                    id: sys.id,
                    label: pageLink.pageName,
                    path: pageLink.slug,
                    externalLink: nil
                )
            },
            twitterLink: graphQLFooter.twitterLink,
            facebookLink: graphQLFooter.facebookLink,
            linkedinLink: graphQLFooter.linkedinLink,
            instagramLink: graphQLFooter.instagramLink
        )
    }
}

extension FooterMenuGroupData {
    static func fromGraphQL(_ graphQLGroup: GraphQLFooterMenuGroup) -> FooterMenuGroupData {
        return FooterMenuGroupData(
            id: graphQLGroup.sys.id,
            groupName: graphQLGroup.groupName,
            menuItems: graphQLGroup.featuredPagesCollection?.items.compactMap { pageLink in
                guard let sys = pageLink.sys else { return nil }
                return MenuItemData(
                    id: sys.id,
                    label: pageLink.pageName,
                    path: pageLink.slug,
                    externalLink: nil
                )
            }
        )
    }
}
