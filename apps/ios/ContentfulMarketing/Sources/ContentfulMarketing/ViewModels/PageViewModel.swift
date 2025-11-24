import Foundation
import SwiftUI

@MainActor
class PageViewModel: ObservableObject {
    @Published var page: Page?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let contentfulService = ContentfulService.shared
    
    func loadPage(slug: String) async {
        isLoading = true
        error = nil
        
        do {
            let loadedPage = try await contentfulService.fetchPage(slug: slug)
            self.page = loadedPage
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}

