import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PageViewModel()
    @State private var selectedSlug: String = "home"
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.error {
                    ErrorView(error: error) {
                        Task {
                            await viewModel.loadPage(slug: selectedSlug)
                        }
                    }
                } else if let page = viewModel.page {
                    ScrollView {
                        VStack(spacing: 0) {
                                PageView(page: page)
                            }
                        }
                } else {
                    VStack(spacing: 20) {
                        Text("Contentful Marketing")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Tap the button below to load content")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Load Home Page") {
                            Task {
                                await viewModel.loadPage(slug: "home")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                }
            }
            .navigationTitle("Contentful Marketing")
            // Don't auto-load on startup to prevent crashes
            // User can tap the button to load content manually
            // .task {
            //     try? await Task.sleep(nanoseconds: 500_000_000)
            //     await viewModel.loadPage(slug: selectedSlug)
            // }
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
                
                // Check if it's a schema mismatch error
                if error.localizedDescription.contains("Schema Mismatch") || 
                   error.localizedDescription.contains("Cannot query field") ||
                   error.localizedDescription.contains("Unknown type") {
                    VStack(alignment: .leading, spacing: 12) {
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
                    .padding(.horizontal)
                } else {
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                
                Button("Retry", action: retry)
                    .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

