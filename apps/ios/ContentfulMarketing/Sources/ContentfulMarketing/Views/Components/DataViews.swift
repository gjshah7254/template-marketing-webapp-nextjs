import SwiftUI
import Kingfisher

// MARK: - Data Model Views

struct HeroBannerDataView: View {
    let data: HeroBannerData
    
    var body: some View {
        ZStack {
            if let imageUrlString = data.imageUrl, let imageUrl = URL(string: imageUrlString) {
                KFImage(imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 400)
                    .clipped()
            }
            
            VStack(spacing: 20) {
                if let headline = data.headline {
                    Text(headline)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                if let subline = data.subline {
                    Text(subline)
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                if let ctaText = data.ctaText {
                    Button(ctaText) {
                        // Handle CTA action
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.3))
        }
    }
}

struct CTADataView: View {
    let data: CTAData
    
    var body: some View {
        VStack(spacing: 16) {
            if let headline = data.headline {
                Text(headline)
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            if let subline = data.subline {
                Text(subline)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            if let ctaText = data.ctaText {
                Button(ctaText) {
                    // Handle CTA action
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct TextBlockDataView: View {
    let data: TextBlockData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let headline = data.headline {
                Text(headline)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            if let bodyText = data.bodyText {
                // For now, just display a placeholder for rich text
                // You can integrate RichTextRenderer here later
                Text("Rich text content")
                    .font(.body)
            }
        }
        .padding()
    }
}

struct InfoBlockDataView: View {
    let data: InfoBlockData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let headline = data.headline {
                Text(headline)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            if let subline = data.subline {
                Text(subline)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 16) {
                if let imageUrlString = data.block1ImageUrl, let imageUrl = URL(string: imageUrlString) {
                    VStack {
                        KFImage(imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                        if let body = data.block1Body {
                            Text("Block 1 content")
                                .font(.caption)
                        }
                    }
                }
                
                if let imageUrlString = data.block2ImageUrl, let imageUrl = URL(string: imageUrlString) {
                    VStack {
                        KFImage(imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                        if let body = data.block2Body {
                            Text("Block 2 content")
                                .font(.caption)
                        }
                    }
                }
                
                if let imageUrlString = data.block3ImageUrl, let imageUrl = URL(string: imageUrlString) {
                    VStack {
                        KFImage(imageUrl)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                        if let body = data.block3Body {
                            Text("Block 3 content")
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct DuplexDataView: View {
    let data: DuplexData
    
    var body: some View {
        HStack(spacing: 20) {
            if data.imageStyle == "left" || data.imageStyle == nil {
                if let imageUrlString = data.imageUrl, let imageUrl = URL(string: imageUrlString) {
                    KFImage(imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                }
            }
            
            VStack(alignment: .leading, spacing: 16) {
                if let headline = data.headline {
                    Text(headline)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                if let bodyText = data.bodyText {
                    Text("Rich text content")
                        .font(.body)
                }
            }
            
            if data.imageStyle == "right" {
                if let imageUrlString = data.imageUrl, let imageUrl = URL(string: imageUrlString) {
                    KFImage(imageUrl)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                }
            }
        }
        .padding()
    }
}

struct QuoteDataView: View {
    let data: QuoteData
    
    var body: some View {
        VStack(spacing: 16) {
            if let quote = data.quote {
                Text("Quote content")
                    .font(.title3)
                    .italic()
            }
            
            if let imageUrlString = data.imageUrl, let imageUrl = URL(string: imageUrlString) {
                KFImage(imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

