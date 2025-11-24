import SwiftUI
import Kingfisher

struct QuoteView: View {
    let quote: Quote
    
    var body: some View {
        VStack(spacing: 20) {
            if let quoteText = quote.quoteText {
                Text(quoteText)
                    .font(.title3)
                    .italic()
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: 12) {
                if let authorImageUrl = quote.authorImage?.url {
                    KFImage(URL(string: authorImageUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading) {
                    if let authorName = quote.authorName {
                        Text(authorName)
                            .fontWeight(.bold)
                    }
                    if let authorTitle = quote.authorTitle {
                        Text(authorTitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

