import Foundation
import SwiftUI

@MainActor
class PageViewModel: ObservableObject {
    @Published var page: Page?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let contentfulService = ContentfulService.shared
    
    func loadPage(slug: String) async {
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        do {
            let loadedPage = try await contentfulService.fetchPage(slug: slug)
            await MainActor.run {
                self.page = loadedPage
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                self.isLoading = false
            }
        }
    }
}

