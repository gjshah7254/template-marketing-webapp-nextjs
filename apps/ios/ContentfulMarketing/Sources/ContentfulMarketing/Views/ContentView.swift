import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PageViewModel()
    @State private var selectedSlug: String = "home"
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    ErrorView(error: error) {
                        Task {
                            await viewModel.loadPage(slug: selectedSlug)
                        }
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            if let page = viewModel.page {
                                PageView(page: page)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Contentful Marketing")
            .task {
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

