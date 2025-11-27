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
            .onAppear {
                // Don't load immediately - let user trigger it manually to avoid crashes
                // Task {
                //     await viewModel.loadPage(slug: selectedSlug)
                // }
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

