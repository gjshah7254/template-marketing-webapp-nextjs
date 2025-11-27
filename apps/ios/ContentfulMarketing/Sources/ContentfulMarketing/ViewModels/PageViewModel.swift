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
        }
        
        do {
            // Add a small delay to ensure app is fully initialized
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            
            let loadedPage = try await contentfulService.fetchPage(slug: slug)
            await MainActor.run {
            self.page = loadedPage
                self.isLoading = false
            }
        } catch {
            // Log error for debugging
            print("Error loading page: \(error)")
            await MainActor.run {
            self.error = error
                self.isLoading = false
            }
        }
    }
}

