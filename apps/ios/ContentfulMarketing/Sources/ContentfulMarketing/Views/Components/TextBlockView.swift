import SwiftUI
import RichTextRenderer
import Contentful

struct TextBlockView: View {
    let textBlock: TextBlock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let headline = textBlock.headline {
                Text(headline)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            if let bodyText = textBlock.bodyText {
                RichTextDocumentView(document: bodyText)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

