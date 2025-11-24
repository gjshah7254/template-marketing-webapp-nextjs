import SwiftUI

struct PageView: View {
    let page: Page
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Section
            if let topSection = page.topSection {
                ForEach(Array(topSection.enumerated()), id: \.offset) { _, component in
                    ComponentView(component: component)
                }
            }
            
            // Main Content
            if let pageContent = page.pageContent {
                ComponentView(component: pageContent)
            }
            
            // Extra Section
            if let extraSection = page.extraSection {
                ForEach(Array(extraSection.enumerated()), id: \.offset) { _, component in
                    ComponentView(component: component)
                }
            }
        }
    }
}

struct ComponentView: View {
    let component: EntryDecodable
    
    var body: some View {
        Group {
            if let heroBanner = component as? HeroBanner {
                HeroBannerView(heroBanner: heroBanner)
            } else if let cta = component as? CTA {
                CTAView(cta: cta)
            } else if let textBlock = component as? TextBlock {
                TextBlockView(textBlock: textBlock)
            } else if let infoBlock = component as? InfoBlock {
                InfoBlockView(infoBlock: infoBlock)
            } else if let duplex = component as? Duplex {
                DuplexView(duplex: duplex)
            } else if let quote = component as? Quote {
                QuoteView(quote: quote)
            }
        }
    }
}

