# Contentful Marketing Monorepo

A monorepo containing three applications that share the same Contentful CMS:
- **Next.js Web App** - Server-side rendered marketing website
- **iOS App** - Native Swift/SwiftUI mobile application
- **Android App** - Native Kotlin/Jetpack Compose mobile application

All three applications connect to the same Contentful space and display the same marketing content, ensuring consistency across all platforms.

![Monorepo Structure](marketing-starter-template.jpg)

## 🏗️ Monorepo Structure

```
contentful-marketing/
├── apps/
│   ├── nextjs/          # Next.js web application
│   ├── ios/             # iOS native app (Swift/SwiftUI)
│   └── android/         # Android native app (Kotlin/Jetpack Compose)
├── packages/            # Shared packages (future use)
├── package.json         # Root package.json for workspace management
└── README.md            # This file
```

## 🚀 Quick Start

### Prerequisites

- **Node.js** >= 18
- **Yarn** (for Next.js app)
- **Xcode** 14+ (for iOS app)
- **Android Studio** (for Android app)
- **Contentful Account** with Space ID and API tokens

### Environment Variables

All three apps require Contentful credentials. Configure them as follows:

#### Next.js App
Create `apps/nextjs/.env`:
```env
CONTENTFUL_SPACE_ID=your_space_id
CONTENTFUL_DELIVERY_ACCESS_TOKEN=your_access_token
ENVIRONMENT_NAME=master
```

#### iOS App
See `apps/ios/ENV_SETUP.md` for detailed instructions.

**Quick setup:**
- Option 1: Edit Scheme → Run → Arguments → Environment Variables
- Option 2: Use `Config.xcconfig` (see `apps/ios/Config.xcconfig.example`)

Required variables:
- `CONTENTFUL_SPACE_ID` = `your_space_id`
- `CONTENTFUL_DELIVERY_ACCESS_TOKEN` = `your_access_token`

#### Android App
See `apps/android/ENV_SETUP.md` for detailed instructions.

**Quick setup:**
- Option 1: Edit `apps/android/gradle.properties` (replace placeholder values)
- Option 2: Use `local.properties` (copy from `local.properties.example`)

Required variables:
```properties
CONTENTFUL_SPACE_ID=your_space_id
CONTENTFUL_DELIVERY_ACCESS_TOKEN=your_access_token
ENVIRONMENT_NAME=master
```

## 📱 Applications

### Next.js Web App

A server-side rendered marketing website built with Next.js, React, and TypeScript.

**Location:** `apps/nextjs/`

**Features:**
- Server-side rendering (SSR)
- GraphQL API integration with code generation
- React Query for data fetching
- Material-UI components
- i18n support
- SEO optimized
- Live preview support

**Getting Started:**
```bash
cd apps/nextjs
yarn install
yarn dev
```

Visit `http://localhost:3000`

**Documentation:** See [apps/nextjs/README.md](apps/nextjs/README.md)

### iOS App

Native iOS application built with Swift and SwiftUI.

**Location:** `apps/ios/`

**Features:**
- SwiftUI-based native interface
- Contentful Swift SDK integration
- Support for all content types
- Image loading with Kingfisher
- Rich text rendering
- Localization support

**Getting Started:**
1. Open `apps/ios/ContentfulMarketing` in Xcode
2. Configure Contentful credentials (see Environment Variables above)
3. Run on simulator or device

**Documentation:** See [apps/ios/README.md](apps/ios/README.md)

### Android App

Native Android application built with Kotlin and Jetpack Compose.

**Location:** `apps/android/`

**Features:**
- Jetpack Compose UI
- Contentful Java SDK integration
- Support for all content types
- Image loading with Coil
- Material Design 3
- Navigation with Jetpack Navigation Compose
- Localization support

**Getting Started:**
1. Open `apps/android` in Android Studio
2. Configure Contentful credentials in `gradle.properties`
3. Sync Gradle files
4. Run on emulator or device

**Documentation:** See [apps/android/README.md](apps/android/README.md)

## 🎨 Shared Content Types

All three applications support the following Contentful content types:

- **Page** - Main page content with sections
- **Hero Banner** - Hero section with headline, image, and CTA
- **CTA** - Call-to-action component
- **Text Block** - Text content with rich text support
- **Info Block** - Information block with image and text
- **Duplex** - Two-column layout with image and text
- **Quote** - Testimonial/quote component
- **Navigation** - Site navigation menu
- **Footer** - Site footer with links and social media
- **Product** - Product information (web app only)
- **Person** - Team member profiles
- **Business Info** - Business information pages

## 🛠️ Development

### Root Scripts

From the root directory, you can run:

```bash
# Next.js app
yarn dev:nextjs          # Start development server
yarn build:nextjs        # Build for production
yarn start:nextjs        # Start production server
yarn type-check:nextjs   # Type check
yarn lint:nextjs         # Lint code
yarn graphql-codegen:nextjs  # Generate GraphQL types
```

### Workspace Management

This monorepo uses Yarn workspaces. Install dependencies for all apps:

```bash
yarn install
```

## 📦 Contentful Setup

1. **Create a Contentful account** (if you don't have one)
   - Visit [contentful.com](https://www.contentful.com)
   - Sign up for a free account

2. **Get your Space ID and API tokens**
   - Space ID: Found in your space settings
   - Access Token: Create a Delivery API token in API keys
   - Preview Token: Create a Preview API token in API keys

3. **Configure all three apps** with the same credentials

4. **Content Model**
   - The Next.js app includes content model migrations
   - Run `yarn migrate:content-model` in the nextjs app to set up content types
   - Or manually create content types in Contentful web app

## 🔄 Content Synchronization

All three apps connect to the same Contentful space, so:

- ✅ Content updates in Contentful automatically appear in all apps
- ✅ No need to update content separately for each platform
- ✅ Consistent content across web, iOS, and Android
- ✅ Single source of truth for all marketing content

## 🏗️ Architecture

### Contentful Integration

- **Next.js**: Uses GraphQL API with React Query hooks (generated via graphql-codegen)
- **iOS**: Uses Contentful Swift SDK with native Swift models
- **Android**: Uses Contentful Java SDK with Kotlin data classes

### Component Mapping

Each platform implements the same content types but with platform-specific UI:

| Content Type | Next.js | iOS | Android |
|-------------|---------|-----|---------|
| Hero Banner | ✅ | ✅ | ✅ |
| CTA | ✅ | ✅ | ✅ |
| Text Block | ✅ | ✅ | ✅ |
| Info Block | ✅ | ✅ | ✅ |
| Duplex | ✅ | ✅ | ✅ |
| Quote | ✅ | ✅ | ✅ |
| Navigation | ✅ | ✅ | ✅ |
| Footer | ✅ | ✅ | ✅ |

## 🚢 Deployment

### Next.js App
- Deploy to Vercel, Netlify, or any Node.js hosting
- Set environment variables in your hosting provider
- See [apps/nextjs/README.md](apps/nextjs/README.md#deployment) for details

### iOS App
- Build and submit to App Store
- Configure Contentful credentials in Xcode build settings or CI/CD

### Android App
- Build APK/AAB and submit to Google Play Store
- Configure Contentful credentials in build.gradle or CI/CD

## 📚 Additional Resources

- [Contentful Documentation](https://www.contentful.com/developers/docs/)
- [Next.js Documentation](https://nextjs.org/docs)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Jetpack Compose Documentation](https://developer.android.com/jetpack/compose)

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Contentful Community**: [Slack](https://www.contentful.com/slack/)
- **Issues**: File an issue in this repository
- **Contentful Support**: [support.contentful.com](https://support.contentful.com/)

---

Built with ❤️ using Contentful, Next.js, Swift, and Kotlin

