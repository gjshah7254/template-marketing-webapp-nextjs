import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PageViewModel()
    @State private var isMenuOpen = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    // Header - fixed at top
                    HeaderView(onMenuClick: {
                        withAnimation {
                            isMenuOpen = true
                        }
                    })
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                    .background(Color(.systemBackground))
                    .zIndex(100)
                    
                    // Content area
                    Group {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if let error = viewModel.error {
                            ErrorView(error: error) {
                                Task {
                                    await viewModel.loadPage(slug: "home")
                                }
                            }
                        } else if let page = viewModel.page {
                            ScrollView {
                                VStack(spacing: 0) {
                                    PageView(page: page)
                                    FooterView(
                                        footer: viewModel.footer,
                                        onNavigate: { path in
                                            Task {
                                                await viewModel.loadPage(slug: path)
                                            }
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                // Mobile Menu - overlays everything, independent of content state
                if isMenuOpen || viewModel.navigation != nil {
                    MobileMenuView(
                        isOpen: $isMenuOpen,
                        menuGroups: viewModel.navigation?.menuItems,
                        onDismiss: {
                            withAnimation {
                                isMenuOpen = false
                            }
                        },
                        onNavigate: { path in
                            Task {
                                await viewModel.loadPage(slug: path)
                            }
                        }
                    )
                    .zIndex(1000) // Ensure menu stays on top
                    .id("mobileMenu") // Stable identity to prevent recreation
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .task {
                await viewModel.loadPage(slug: "home")
            }
        }
    }
}

struct ErrorView: View {
    let error: Error
    let retry: () -> Void
    
    var body: some View {
        ScrollView {
        VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.orange)
                
            Text("Error loading content")
                .font(.headline)
                
                // Always show the full error message for debugging
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                // Check if it's a schema mismatch error
                if error.localizedDescription.contains("Schema Mismatch") || 
                   error.localizedDescription.contains("Cannot query field") ||
                   error.localizedDescription.contains("Unknown type") {
                        Text("Configuration Issue")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("The app is using the wrong Contentful space. Please configure it with the same space ID and access token that your Next.js app uses.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("To fix this:")
                                .font(.caption)
                                .fontWeight(.semibold)
                            
                            Text("1. Get your Contentful credentials (Space ID & Access Token)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("2. In Xcode: Edit Scheme → Run → Arguments → Environment Variables")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("3. Add CONTENTFUL_SPACE_ID and CONTENTFUL_DELIVERY_ACCESS_TOKEN")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("4. Clean build folder and rebuild")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        // Always show error details
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Error Details:")
                                .font(.caption)
                                .fontWeight(.semibold)
                            Text(error.localizedDescription)
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(.secondary)
                                .textSelection(.enabled)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                        .padding(.horizontal)
                }
                
            Button("Retry", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        }
    }
}

