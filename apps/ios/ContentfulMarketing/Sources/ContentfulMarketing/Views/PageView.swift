import SwiftUI

struct PageView: View {
    let page: PageData
    
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
    let component: ComponentData
    
    var body: some View {
        Group {
            switch component {
            case .heroBanner(let data):
                HeroBannerDataView(data: data)
            case .cta(let data):
                CTADataView(data: data)
            case .textBlock(let data):
                TextBlockDataView(data: data)
            case .infoBlock(let data):
                InfoBlockDataView(data: data)
            case .duplex(let data):
                DuplexDataView(data: data)
            case .quote(let data):
                QuoteDataView(data: data)
            }
        }
    }
}

