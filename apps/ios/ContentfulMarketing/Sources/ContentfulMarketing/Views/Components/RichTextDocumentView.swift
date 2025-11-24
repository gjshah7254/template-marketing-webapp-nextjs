import SwiftUI
import RichTextRenderer
import Contentful

struct RichTextDocumentView: UIViewControllerRepresentable {
    let document: RichTextDocument
    
    func makeUIViewController(context: Context) -> RichTextViewController {
        let renderer = RichTextDocumentRenderer()
        let viewController = RichTextViewController(renderer: renderer, richTextDocument: document)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: RichTextViewController, context: Context) {
        // Update if needed
    }
}

