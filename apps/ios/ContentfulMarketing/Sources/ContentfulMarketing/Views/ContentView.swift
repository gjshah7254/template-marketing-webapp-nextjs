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
                        Text("No content available")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Button("Load Home Page") {
                            Task {
                                await viewModel.loadPage(slug: "home")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Contentful Marketing")
            .task {
                // Delay initial load slightly to ensure app is fully initialized
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                await viewModel.loadPage(slug: selectedSlug)
            }
        }
    }
}

struct ErrorView: View {
    let error: Error
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Error loading content")
                .font(.headline)
            Text(error.localizedDescription)
                .font(.caption)
                .foregroundColor(.secondary)
            Button("Retry", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

