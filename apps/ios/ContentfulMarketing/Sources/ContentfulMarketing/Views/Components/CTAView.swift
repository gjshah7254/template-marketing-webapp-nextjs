import SwiftUI

struct CTAView: View {
    let cta: CTA
    
    var body: some View {
        VStack(spacing: 20) {
            if let headline = cta.headline {
                Text(headline)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
            
            if let subline = cta.subline {
                Text(subline)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let ctaText = cta.ctaText {
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

