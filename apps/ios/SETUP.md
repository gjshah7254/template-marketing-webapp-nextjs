# iOS App Setup Guide

## Current Structure

The current structure is a **Swift Package**, which is used for libraries. For an iOS app, we need an **Xcode Project**.

## Option 1: Create Xcode Project Manually (Recommended)

1. **Open Xcode** and create a new project:
   - File → New → Project
   - Choose "iOS" → "App"
   - Product Name: `ContentfulMarketing`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Save it in `apps/ios/` (this will create `ContentfulMarketing.xcodeproj`)

2. **Add Swift Package Dependencies**:
   - In Xcode, go to File → Add Package Dependencies
   - Add these packages:
     - `https://github.com/contentful/contentful.swift` (version 5.0.0 or later)
     - `https://github.com/contentful/rich-text-renderer.swift` (version 1.0.0 or later)
     - `https://github.com/onevcat/Kingfisher` (version 7.0.0 or later)

3. **Move Source Files**:
   - Delete the default `ContentView.swift` and `App.swift` that Xcode created
   - Copy all files from `ContentfulMarketing/Sources/ContentfulMarketing/` to your new Xcode project's source folder
   - Make sure to add them to the target in Xcode

4. **Configure Environment Variables**:
   - Select your app target → Edit Scheme → Run → Arguments
   - Add Environment Variables:
     - `CONTENTFUL_SPACE_ID` = your_space_id
     - `CONTENTFUL_ACCESS_TOKEN` = your_access_token
     - `CONTENTFUL_PREVIEW_ACCESS_TOKEN` = your_preview_token (optional)
     - `CONTENTFUL_USE_PREVIEW` = false (or true for preview mode)

5. **Build and Run**:
   - Select a simulator or device
   - Press ⌘R to build and run

## Option 2: Use XcodeGen (Advanced)

If you prefer a code-based approach, you can use [XcodeGen](https://github.com/yonaskolb/XcodeGen):

1. Install XcodeGen:
   ```bash
   brew install xcodegen
   ```

2. I'll create a `project.yml` file for you (see below)

3. Generate the project:
   ```bash
   cd apps/ios
   xcodegen generate
   ```

4. Open the generated `.xcodeproj` in Xcode

## Option 3: Convert Swift Package to App (Quick Fix)

You can also open the Package.swift directly in Xcode, but you'll need to:

1. Open `Package.swift` in Xcode (File → Open → select `apps/ios/Package.swift`)
2. Xcode will open it as a Swift Package
3. To make it an app, you'll need to create an app target manually or use the steps above

## Recommended: Use Option 1

The manual approach (Option 1) is the most straightforward and gives you full control over the project structure.

