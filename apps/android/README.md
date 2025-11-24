# Contentful Marketing Android App

Native Android app built with Kotlin and Jetpack Compose that connects to Contentful CMS and displays marketing content.

## Features

- Jetpack Compose-based native Android interface
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
- Image loading with Coil
- Material Design 3
- Navigation with Jetpack Navigation Compose
- Localization support

## Setup

1. **Configure Contentful credentials** in `gradle.properties` or `local.properties`:
   ```properties
   CONTENTFUL_SPACE_ID=your_space_id
   CONTENTFUL_ACCESS_TOKEN=your_access_token
   CONTENTFUL_PREVIEW_ACCESS_TOKEN=your_preview_token
   ```

2. **Sync Gradle files**: Open the project in Android Studio and click "Sync Project with Gradle Files" (or File → Sync Project with Gradle Files).

3. **If you encounter dependency resolution errors**:
   - Make sure you have an active internet connection
   - Try "Invalidate Caches / Restart" in Android Studio (File → Invalidate Caches...)
   - Clean and rebuild the project (Build → Clean Project, then Build → Rebuild Project)
   - Ensure your `local.properties` file has the correct Android SDK path

4. **Run the app** on an emulator or device.

## Project Structure

```
app/
├── src/
│   └── main/
│       ├── java/com/contentful/marketing/
│       │   ├── data/              # Data models and Contentful service
│       │   ├── ui/
│       │   │   ├── screens/       # Screen composables
│       │   │   ├── components/    # Reusable UI components
│       │   │   └── theme/         # Material Design theme
│       │   ├── MainActivity.kt
│       │   └── ContentfulMarketingApp.kt
│       └── AndroidManifest.xml
└── build.gradle.kts
```

## Dependencies

- Jetpack Compose
- Contentful GraphQL API (via Retrofit) - Using GraphQL API directly instead of Java SDK
- Coil (for image loading)
- Navigation Compose
- Material Design 3
- Retrofit & OkHttp (for networking)

## Building

```bash
./gradlew build
```

## Running

Open the project in Android Studio and run on an emulator or device.

