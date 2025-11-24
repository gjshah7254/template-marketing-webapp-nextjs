# Contentful Marketing iOS App

Native iOS app built with SwiftUI that connects to Contentful CMS and displays marketing content.

## Features

- SwiftUI-based native iOS interface
- Contentful SDK integration
- Support for all content types from the web app:
  - Hero Banner
  - CTA (Call to Action)
  - Text Block
  - Info Block
  - Duplex
  - Quote
  - Navigation
  - Footer
- Image loading with Kingfisher
- Rich text rendering
- Localization support

## Setup

### Important: Create Xcode Project First

The current structure is a Swift Package. For an iOS app, you need an **Xcode Project** (`.xcodeproj`).

**Quick Setup:**

1. **Open Xcode** → File → New → Project
2. Choose **iOS** → **App**
3. Product Name: `ContentfulMarketing`
4. Interface: **SwiftUI**
5. Language: **Swift**
6. Save in `apps/ios/` folder

7. **Add Swift Package Dependencies** (File → Add Package Dependencies):
   - `https://github.com/contentful/contentful.swift` (from: 5.0.0)
   - `https://github.com/contentful/rich-text-renderer.swift` (from: 1.0.0)
   - `https://github.com/onevcat/Kingfisher` (from: 7.0.0)

8. **Copy Source Files**:
   - Delete default `ContentView.swift` and `App.swift`
   - Copy all files from `ContentfulMarketing/Sources/ContentfulMarketing/` to your Xcode project
   - Make sure to add them to the target

9. **Configure Environment Variables** (Edit Scheme → Run → Arguments → Environment Variables):
   - `CONTENTFUL_SPACE_ID`: Your Contentful Space ID
   - `CONTENTFUL_ACCESS_TOKEN`: Your Contentful Delivery API token
   - `CONTENTFUL_PREVIEW_ACCESS_TOKEN`: Your Contentful Preview API token (optional)
   - `CONTENTFUL_USE_PREVIEW`: Set to "true" to use preview API (optional)

10. **Build and Run** (⌘R)

**Alternative: Use XcodeGen** (see `SETUP.md` for details)

## Project Structure

```
ContentfulMarketing/
├── Sources/
│   └── ContentfulMarketing/
│       ├── Models/          # Contentful content models
│       ├── Views/           # SwiftUI views
│       ├── ViewModels/      # View models for state management
│       ├── Services/        # Contentful service layer
│       ├── Components/      # Reusable UI components
│       └── Utils/           # Utility functions
└── Package.swift            # Swift Package Manager configuration
```

## Dependencies

- Contentful Swift SDK
- Contentful Rich Text Renderer
- Kingfisher (for image loading)

## Building

```bash
swift build
```

## Running

Open the project in Xcode and run on a simulator or device.

