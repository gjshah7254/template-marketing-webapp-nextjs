import Foundation
import SwiftUI

@MainActor
class PageViewModel: ObservableObject {
    @Published var page: PageData?
    @Published var navigation: NavigationData?
    @Published var footer: FooterData?
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
            // Fetch page first - this is critical
            let pageResult = try await contentfulService.fetchPage(slug: slug)
            
            await MainActor.run {
                if let page = pageResult {
                    self.page = page
                    self.isLoading = false
                } else {
                    self.error = NSError(domain: "PageViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: "No page found with slug: \(slug). Please check if the page exists in Contentful."])
                    self.isLoading = false
                }
            }
            
            // Fetch navigation separately - don't fail if this errors
            do {
                let navigationResult = try await contentfulService.fetchNavigation()
                await MainActor.run {
                    self.navigation = navigationResult
                }
            } catch {
                // Log navigation error but don't fail the page load
                print("Warning: Failed to load navigation: \(error.localizedDescription)")
                await MainActor.run {
                    // Navigation is optional, so we don't set an error here
                }
            }
            
            // Fetch footer separately - don't fail if this errors
            do {
                let footerResult = try await contentfulService.fetchFooter()
                await MainActor.run {
                    self.footer = footerResult
                }
            } catch {
                // Log footer error but don't fail the page load
                print("Warning: Failed to load footer: \(error.localizedDescription)")
                await MainActor.run {
                    // Footer is optional, so we don't set an error here
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

