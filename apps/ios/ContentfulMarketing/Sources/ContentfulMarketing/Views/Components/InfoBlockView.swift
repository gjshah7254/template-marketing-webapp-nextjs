import SwiftUI
import Kingfisher
import RichTextRenderer
import Contentful

struct InfoBlockView: View {
    let infoBlock: InfoBlock
    
    var body: some View {
        VStack(spacing: 20) {
            if let imageUrl = infoBlock.image?.url {
                KFImage(imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 300)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                if let headline = infoBlock.headline {
                    Text(headline)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                if let bodyText = infoBlock.bodyText {
                    RichTextDocumentView(document: bodyText)
                }
            }
        }
        .padding()
    }
}

