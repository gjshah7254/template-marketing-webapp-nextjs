import SwiftUI
import Kingfisher
import ContentfulRichTextRenderer

struct DuplexView: View {
    let duplex: Duplex
    let imageFirst: Bool
    
    init(duplex: Duplex) {
        self.duplex = duplex
        self.imageFirst = duplex.imagePosition == "left"
    }
    
    var body: some View {
        HStack(spacing: 20) {
            if imageFirst {
                imageView
                contentView
            } else {
                contentView
                imageView
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let imageUrl = duplex.image?.url {
            KFImage(URL(string: imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let headline = duplex.headline {
                Text(headline)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            if let bodyText = duplex.bodyText {
                RichTextDocumentView(document: bodyText)
            }
        }
    }
}

