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

1. Install dependencies using Swift Package Manager:
   ```bash
   swift package resolve
   ```

2. Configure Contentful credentials in your Xcode scheme or Info.plist:
   - `CONTENTFUL_SPACE_ID`: Your Contentful Space ID
   - `CONTENTFUL_ACCESS_TOKEN`: Your Contentful Delivery API token
   - `CONTENTFUL_PREVIEW_ACCESS_TOKEN`: Your Contentful Preview API token (optional)
   - `CONTENTFUL_USE_PREVIEW`: Set to "true" to use preview API (optional)

3. Open the project in Xcode and run.

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

