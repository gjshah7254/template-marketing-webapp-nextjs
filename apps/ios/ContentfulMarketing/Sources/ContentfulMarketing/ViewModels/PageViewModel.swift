import Foundation
import SwiftUI

@MainActor
class PageViewModel: ObservableObject {
    @Published var page: PageData?
    @Published var isLoading = false
    @Published var error: Error?
    
    // Lazy initialization to prevent crashes during app startup
    private lazy var contentfulService: ContentfulService = {
        return ContentfulService.shared
    }()
    
    func loadPage(slug: String) async {
        await MainActor.run {
            isLoading = true
            error = nil
            page = nil
        }
        
        do {
            let loadedPage = try await contentfulService.fetchPage(slug: slug)
            
            await MainActor.run {
                if let page = loadedPage {
                    self.page = page
                    self.isLoading = false
                } else {
                    self.error = NSError(domain: "PageViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: "No page found with slug: \(slug). Please check if the page exists in Contentful."])
                    self.isLoading = false
                }
            }
        } catch {
            await MainActor.run {
                self.error = error
                self.isLoading = false
            }
        }
    }
}

