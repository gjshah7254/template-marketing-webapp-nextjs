import SwiftUI
import Kingfisher

struct HeroBannerView: View {
    let heroBanner: HeroBanner
    
    var body: some View {
        ZStack {
            if let imageUrl = heroBanner.image?.url {
                KFImage(imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 400)
                    .clipped()
            }
            
            VStack(spacing: 20) {
                if let headline = heroBanner.headline {
                    Text(headline)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                if let subline = heroBanner.subline {
                    Text(subline)
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                if let ctaText = heroBanner.ctaText {
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

